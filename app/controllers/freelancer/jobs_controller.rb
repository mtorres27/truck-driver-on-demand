class Freelancer::JobsController < Freelancer::BaseController
  include JobHelper

  def index
    authorize current_user

    if params[:search].nil? || (params[:search][:keywords].blank? && params[:search][:country].blank? && params[:search][:state_province].blank? && params[:search][:address].blank?)
      flash[:error] = "You'll need to add some search criteria to narrow your search results!"
      redirect_to freelancer_root_path
    end

    @keywords = params.dig(:search, :keywords).presence
    @country = params.dig(:search, :country).presence
    @state_province = params.dig(:search, :state_province).presence
    @address = params.dig(:search, :address).presence

    @sort = params.dig(:search, :sort).presence
    @distance = params.dig(:search, :distance).presence

    if @sort == "ASC"
      sort = :asc
    elsif @sort == "DESC"
      sort = :desc
    elsif @sort == "RELEVANCE"
      sort = nil
    end

    if sort != nil
      @jobs = Job.joins(:company).where(companies: { disabled: false }).where.not(companies: { plan_id: nil }).where(state: "published").order(name: sort)
    else
      @jobs = Job.joins(:company).where(companies: { disabled: false }).where.not(companies: { plan_id: nil }).where(state: "published").all
    end

    if @address
      # check for cached version of address
      @address_for_geocode = @address
      @address_for_geocode += ", #{CS.states(@country.to_sym)[@state_province.to_sym]}" if @state_province.present?
      @address_for_geocode += ", #{CS.countries[@country.upcase.to_sym]}" if @country.present?
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
          @distance = 60000
        end
        @jobs = @jobs.nearby(@geocode[:lat], @geocode[:lng], @distance).with_distance(point).order("distance")
      else
        @jobs = Job.none
      end
    end

    @jobs = @jobs.search(@keywords) if @keywords
    @jobs = @jobs.where(country: @country) if @country
    @jobs = @jobs.where(state_province: @state_province) if @state_province

    @jobs = @jobs.page(params[:page]).per(50)
  end

  def favourites
    authorize current_user

    @locations = current_user.favourite_jobs.uniq.pluck(:area)
    @jobs = current_user.favourite_jobs

    if params[:location] && params[:location] != ""
      @jobs = @jobs.where({ area: params[:location] })
    end

    @jobs = @jobs.page(params[:page]).
      per(50)
  end

  def apply
    @stripe_connector = StripeAccount.new(current_user)
    @applicant = Applicant.new
    @job = Job.find(params[:id])
    authorize @job

    @applicant.freelancer = current_user
    @applicant.job = @job
    @applicant.company = @job.company

    # if !@stripe_connector.verified? && !Rails.env.development?
    if !@stripe_connector.verified?
      redirect_to freelancer_job_path(@job), alert: "You need to verify your identity before applying for a job."
    elsif apply_params[:message].nil?
      redirect_to freelancer_job_path(@job), alert: "Required data not found; please ensure your message has been entered."
    else
      if @applicant.save
        @applicant.messages << Message.create({
          authorable: current_user,
          body: apply_params[:message],
          attachment: apply_params[:attachment]
        })

        @message = @applicant.messages.last
        @message.save

        # add quote
        Notification.create(title: @job.title, body: "#{@applicant.freelancer.first_name_and_initial} applied for this job", authorable: @applicant.freelancer, receivable: @job.company, url: company_job_applicants_url(@job))
        CompanyMailer.notice_message_received(@job.company, @applicant.freelancer, @job, @message).deliver_later
        redirect_to freelancer_job_application_index_path(@job), notice: "Application successfully submitted"
      else
        # error message; redirect back to job page
        redirect_to freelancer_job_path(@job), notice: "Unable to save applicant information"
      end
    end
  end


  def show
    @job = Job.find(params[:id])
    authorize @job

    if @job.applicants.where({freelancer_id: current_user.id}).count == 0
      @have_applied = false
    else
      @have_applied = true
    end

    @favourite = current_user.job_favourites.where({job_id: params[:id]}).length > 0 ? true : false
    if params.dig(:toggle_favourite) == "true"
      if @favourite == false
        current_user.favourite_jobs << @job
        @favourite = true
      else
        current_user.job_favourites.where({job_id: @job.id}).destroy_all
        @favourite = false
      end
    end

    @connector = StripeAccount.new(current_user)
  end


  def my_job
    @job = Job.find(params[:id])
    authorize @job, :show?
    render :json => { status: @job.title }
  end


  def my_jobs
    authorize current_user

    @applications = []
    current_user.applicants.where.not({ state: "accepted" }).each do |applicant|
      @applications << applicant.job
    end

    @jobs = []
    current_user.applicants.where({ state: "accepted" }).each do |job|
      @found = false
      @applications.each do |application|
        if job.id == application.id
          @found = true
        end
      end

      if @found == false
        @jobs << job.job
      end
    end
  end


  def my_applications
    authorize current_user
    @jobs = []
    current_user.applicants.where.not({state: 'accepted'}).each do |applicant|
      @jobs << { job: applicant.job, applicant: applicant }
    end
  end


  def my_application
    @applicant = Applicant.find(params[:id])
    @job = @applicant.job
    authorize @job
    render :json => { status: @job.title }
  end


  def show_job
    @job = Job.find(params[:id])
    authorize @job, :show?
  end


  def add_favourites
    authorize current_user

    if params[:companies].nil?
      render json: { status: 'parameter missing' }
      return
    end

    params[:companies].each do |id|
      c = Company.where({ id: id.to_i })

      if f.length > 0
        current_user.favourite_companies << c.first
      end
    end

    render json: { status: 'success', companies: params[:companies] }
  end

  def job_matches
    authorize current_user
    @jobs = Job.none
    current_user.freelancer_profile.job_types.each do |index, _value|
      @jobs = @jobs.or(Job.where(job_type: index))
    end
    @distance = params[:search][:distance] if params[:search].present?
    @address = ''
    @address += "#{current_user.freelancer_profile.address}, " if current_user.freelancer_profile.address.present?
    @address += current_user.freelancer_profile.city if current_user.freelancer_profile.city.present?
    @address += ", #{CS.states(current_user.freelancer_profile.country.upcase.to_sym)[current_user.freelancer_profile.state.to_sym]}" if current_user.freelancer_profile.country.present?
    @address += ", #{CS.countries[current_user.freelancer_profile.country.upcase.to_sym]}" if current_user.freelancer_profile.country.present?
    if @address
      # check for cached version of address
      if Rails.cache.read(@address)
        @geocode = Rails.cache.read(@address)
      else
        # save cached version of address
        @geocode = do_geocode(@address)
        Rails.cache.write(@address, @geocode)
      end

      if @geocode
        point = OpenStruct.new(:lat => @geocode[:lat], :lng => @geocode[:lng])
        if @distance.nil?
          @distance = 160000
        end
        @jobs = @jobs.nearby(@geocode[:lat], @geocode[:lng], @distance).with_distance(point).order("distance")
      else
        @jobs = Job.none
      end
    end
    @jobs = @jobs.page(params[:page]).per(10)
  end

  private

  def apply_params
    params.require(:freelancer_job_apply_path).permit(
      :job,
      :message,
      :attachment,
      :body
    )
  end
end
