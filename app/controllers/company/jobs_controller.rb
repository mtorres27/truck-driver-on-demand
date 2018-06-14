class Company::JobsController < Company::BaseController
  before_action :set_job, except: [:job_countries, :new, :create]
  before_action :authorize_job, except: [:job_countries, :new, :create]

  def avj_invoice

  end

  def print_avj_invoice

  end

  def contract_invoice
    @accepted_quote = @job.accepted_quote
  end

  def new
    if params[:job]
      @job = current_company.jobs.build(job_params)
    else
      @job = current_company.jobs.build(project_id: params[:project_id])
    end

    authorize @job

    @currencies = [
      ["Canadian Dollars", "cad"],
      ["Euro", "euro"],
      ["Ruble", "ruble"],
      ["Rupee", "rupee"],
      ["US Dollars", "usd"],
      ["Yen", "yen"]
    ]
  end

  def create
    if (!['trialing', 'active'].include?(current_company.subscription_status))
      flash[:notice] = "You need to subscribe to be able to post new jobs."
      redirect_to company_projects_path && return
    end

    @job = Job.new(job_params)
    @job.company = current_company

    authorize @job

    validate_ownership
    if @job.errors.size > 0
      render :new
      return
    end

    @job.published = true if job_params[:published]

    if @job.save
      redirect_to company_job_path(@job)
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def publish
    if @job.company.id != current_company.id
      redirect_to company_job_path(@job)
      return
    end
    if @job.errors.size > 0
      render :edit
      return
    end

    @job.state = "published"

    if @job.save
      flash[:notice] = "This job has been published."
      redirect_to company_job_path(@job)
    else
      render :edit
    end
  end

  def update
    validate_ownership
    if @job.errors.size > 0
      render :edit
      return
    end

    if @job.update(job_params)
      if params.dig(:job, :send_contract).presence
        @m = Message.new
        @m.authorable = @job.company
        @m.receivable = @job.freelancer
        @m.send_contract = true
        @m.body = "Hi #{@job.freelancer}! This is a note to let you know that we've just sent a contract to you. <a href='/freelancer/jobs/#{@job.id}/work_order'>Click here</a> to view it!"
        @m.save
      end

      redirect_to company_job_path(@job)
    else
      render :edit
    end
  end


  def destroy
    @job.destroy
    redirect_to company_projects_path, notice: "Job removed."
  end

  def freelancer_matches
    @jobs = @job.company.jobs
    @distance = params[:search][:distance] if params[:search].present?
    @freelancer_profiles = FreelancerProfile.where(disabled: false).where("job_types like ?", "%#{@job.job_type}%")
    @freelancers = Freelancer.where(id: @freelancer_profiles.map(&:freelancer_id))
    @address_for_geocode = @job.address
    @address_for_geocode += ", #{CS.states(@job.country.to_sym)[@job.state_province.to_sym]}" if @job.state_province.present?
    @address_for_geocode += ", #{CS.countries[@job.country.upcase.to_sym]}" if @job.country.present?

    # check for cached version of address
    if Rails.cache.read(@address_for_geocode)
      @geocode = Rails.cache.read(@address_for_geocode)
    else
      # save cached version of address
      @geocode = do_geocode(@address_for_geocode)
      Rails.cache.write(@address_for_geocode, @geocode)
    end

    if @geocode
      point = OpenStruct.new(:lat => @geocode[:lat], :lng => @geocode[:lng])
      if @distance.nil?
        @distance = 160934
      end
      @freelancer_profiles = FreelancerProfile.where(freelancer_id: @freelancers.map(&:id))
      @freelancer_profiles = @freelancer_profiles.nearby(@geocode[:lat], @geocode[:lng], @distance).with_distance(point).order("distance")
      @freelancers = Freelancer.where(id: @freelancer_profiles.map(&:freelancer_id))
    else
      flash[:error] = "Unable to search geocode. Please try again."
      @freelancers = Freelancer.none
    end
  end


  private

  def set_job
    @job = current_company.jobs.find(params[:id])
  end

  def authorize_job
    authorize @job
  end

  def validate_ownership
    unless job_params[:project_id].present? && current_company.projects.find(job_params[:project_id])
      @job.errors[:project_id] << "Invalid project selected"
    end
  end

  def job_params
    params.require(:job).permit(
      :project_id,
      :title,
      :summary,
      :scope_of_work,
      :scope_file,
      :budget,
      :country,
      :currency,
      :job_type,
      :job_market,
      :job_function,
      :pay_type,
      :starts_on,
      :duration,
      :freelancer_type,
      :invite_only,
      :scope_is_public,
      :budget_is_public,
      :state,
      :address,
      :state_province,
      attachments_attributes: [:id, :file, :title, :_destroy],
      technical_skill_tags:  I18n.t("enumerize.technical_skill_tags").keys,
      manufacturer_tags:  I18n.t("enumerize.manufacturer_tags").keys,
    )
  end
end
