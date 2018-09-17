class Admin::JobsController < Admin::BaseController
  before_action :set_job, only: [:show, :edit, :update, :destroy, :freelancer_matches]
  before_action :authorize_job, only: [:show, :edit, :update, :destroy, :freelancer_matches]

  def index
    authorize current_user
    @keywords = params.dig(:search, :keywords).presence
    @jobs = Job.order(:title)
    if @keywords
      @jobs = @jobs.search(@keywords)
    end
    @jobs = @jobs.page(params[:page])
  end

  def show
  end

  def edit
    @company = @job.company
  end

  def update
    @company = @job.company
    if @job.update(job_params)
      redirect_to admin_job_path(@job), notice: "Job updated."
    else
      render :edit
    end
  end

  def destroy
    @job.destroy
    redirect_to admin_jobs_path, notice: "Jobs removed."
  end

  def freelancer_matches
    get_matches
  end

  private

  def get_matches
    @distance = params[:search][:distance] if params[:search].present?
    @freelancer_profiles = FreelancerProfile.where(disabled: false).where("job_types like ?", "%#{@job.job_type}%")
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
      @freelancer_profiles = @freelancer_profiles.nearby(@geocode[:lat], @geocode[:lng], @distance).with_distance(point).order("distance")
      @freelancers = Freelancer.where(id: @freelancer_profiles.map(&:freelancer_id))
    else
      flash[:error] = "Unable to search geocode. Please try again."
      @freelancers = Freelancer.none
    end
  end

  def set_job
    @job = Job.find(params[:id])
  end

  def authorize_job
    authorize @job
  end

  def job_params
    params.require(:job).permit(
      :title,
      :state,
      :summary,
      :scope_of_work,
      :scope_file,
      :budget,
      :job_type,
      :job_market,
      :job_function,
      :starts_on,
      :ends_on,
      :duration,
      :pay_type,
      :freelancer_type,
      :invite_only,
      :scope_is_public,
      :budget_is_public,
      :contract_price,
      :payment_schedule,
      :reporting_frequency,
      :require_photos_on_updates,
      :require_checkin,
      :require_uniform,
      :state_province,
      technical_skill_tags:  I18n.t("enumerize.technical_skill_tags").keys,
      manufacturer_tags:  I18n.t("enumerize.manufacturer_tags").keys,
    )
  end
end
  