class Freelancer::JobsController < Freelancer::BaseController
  include JobHelper

  def index
    @keywords = params.dig(:search, :keywords).presence
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
      @jobs = Job.where({ state: "published" }).order(name: sort)
    else
      @jobs = Job.where({ state: "published" }).all
    end

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
          @distance = 60000
        end
        @jobs = @jobs.nearby(@geocode[:lat], @geocode[:lng], @distance).with_distance(point).order("distance")
      else
        @jobs = Job.none
      end
    end

    if @keywords
      @jobs = @jobs.search(@keywords)
    end

    @jobs = @jobs.page(params[:page]).per(50)
  end

  def favourites
    @locations = current_freelancer.favourite_jobs.uniq.pluck(:area)
    @jobs = current_freelancer.favourite_jobs

    if params[:location] && params[:location] != ""
      @jobs = @jobs.where({ area: params[:location] })
    end

    @jobs = @jobs.page(params[:page]).
      per(50)
  end

  def apply
    @applicant = Applicant.new
    @job = Job.find(params[:id])

    @applicant.freelancer = current_freelancer
    @applicant.job = @job
    @applicant.company = @job.company

    if apply_params[:message].nil? or apply_params[:pay_type].nil?
      redirect_to freelancer_job_path(@job), alert: "Required data not found; please ensure your message and amount have both been entered."
    else
      if @applicant.save
        @applicant.messages << Message.create({
          authorable: current_freelancer,
          body: apply_params[:message],
        })

        if apply_params[:pay_type] == "fixed"
          @applicant.quotes << Quote.create({
            company: @job.company, 
            pay_type: apply_params[:pay_type],
            amount: apply_params[:amount],
            attachment: apply_params[:attachment]
          })
        elsif apply_params[:pay_type] == "hourly"
          @applicant.quotes << Quote.create({
            company: @job.company, 
            pay_type: apply_params[:pay_type],
            hourly_rate: apply_params[:hourly_rate],
            amount: (apply_params[:hourly_rate].to_i * apply_params[:number_of_hours].to_i),
            number_of_hours: apply_params[:number_of_hours],
            attachment: apply_params[:attachment]
          })
        elsif apply_params[:pay_type] == "daily"
          @applicant.quotes << Quote.create({
            company: @job.company, 
            pay_type: apply_params[:pay_type],
            daily_rate: apply_params[:daily_rate],
            amount: (apply_params[:daily_rate].to_i * apply_params[:number_of_days].to_i),
            number_of_days: apply_params[:number_of_days],
            attachment: apply_params[:attachment]
          })
        end

        # add quote
        redirect_to freelancer_path(@job), notice: "Application successfully submitted"
      else
        # error message; redirect back to job page
        redirect_to freelancer_job_path(@job), notice: "Unable to save applicant information"
      end
    end
  end


  def show
    @job = Job.find(params[:id])

    if @job.applicants.where({freelancer_id: current_freelancer.id}).count == 0
      @have_applied = false
    else
      @have_applied = true
    end

    @favourite = current_freelancer.job_favourites.where({job_id: params[:id]}).length > 0 ? true : false
    if params.dig(:toggle_favourite) == "true" 
      if @favourite == false
        current_freelancer.favourite_jobs << @job
        @favourite = true
      else
        current_freelancer.job_favourites.where({job_id: @job.id}).destroy_all
        @favourite = false
      end
    end
  end
  

  def my_job
    @job = Job.find(params[:id])
    render :json => { status: @job.title }
  end

  
  def my_jobs
    @applications = []
    current_freelancer.applicants.where.not({ state: "accepted" }).each do |applicant|
      @applications << applicant.job
    end

    @jobs = []
    current_freelancer.applicants.where({ state: "accepted" }).each do |job|
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
    @jobs = []
    current_freelancer.applicants.where.not({state: 'accepted'}).each do |applicant|
      @jobs << { job: applicant.job, applicant: applicant }
    end
  end
  

  def my_application
    @applicant = Applicant.find(params[:id])
    @job = @applicant.job
    render :json => { status: @job.title }
  end


  def show_job
    @job = Job.find(params[:id])
  end


  def add_favourites
    if params[:companies].nil?
      render json: { status: 'parameter missing' }
      return
    end

    params[:companies].each do |id|
      c = Company.where({ id: id.to_i })

      if f.length > 0
        current_freelancer.favourite_companies << c.first
      end
    end
          
    render json: { status: 'success', companies: params[:companies] }
  end

  private
  
    def apply_params
      params.require(:freelancer_job_apply_path).permit(
        :pay_type,
        :job,
        :amount,
        :number_of_hours,
        :hourly_rate,
        :message,
        :attachment,
        :daily_rate,
        :number_of_days,
        :body
      )
    end
end
