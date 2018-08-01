class Company::QuotesController < Company::BaseController
  before_action :set_applicant
  before_action :authorize_job

  def index
    set_collections
  end

  def create
    set_collections

    if !params[:message][:status].nil?
      @status = params[:message][:status]
      params[:message].delete :status
    else
      @status = ""
    end

    @message = @applicant.messages.new({ body: params[:message][:body], attachment: params[:message][:attachment] })
    @message.authorable = current_company

    if @message.save
      FreelancerMailer.notice_message_received(current_company, @applicant.freelancer, @job, @message).deliver_later
      redirect_to company_job_applicant_quotes_path(@job, @applicant)
    else
      set_collections
      render :index
    end
  end

  private

  def set_job
    @job = current_company.jobs.includes(applicants: [:messages]).find(params[:job_id])
  end

  def set_applicant
    set_job
    if params[:applicant_id]
      @applicant = @job.applicants.find(params[:applicant_id])
    else
      @applicant = @job.applicants.without_state(:ignored).includes(:messages).order("messages.created_at").first
    end
  end

  def authorize_job
    authorize @job
  end

  def set_collections
    @messages = @applicant.messages
    @applicants = @applicant.job.applicants.without_state(:ignored)

    if @applicants.where({state: "accepted"}).length > 0
      @applicant_accepted = true
    else
      @applicant_accepted = false
    end

    if params[:filter].presence
      @applicants = @applicants.where({state: params[:filter]})
    end

    @current_applicant_id = @applicant.id
  end

  def message_params
    params.require(:message).permit(:body, :attachment)
  end
end
