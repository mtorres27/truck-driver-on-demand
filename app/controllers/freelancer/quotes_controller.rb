class Freelancer::QuotesController < Freelancer::BaseController
  before_action :set_applicant
  before_action :authorize_job

  def index
    set_collections
  end

  def create
    set_collections

    @message = @applicant.messages.new(message_params)
    @message.has_quote = true
    @message.authorable = current_user
    
    if @message.save
      redirect_to freelancer_job_application_index_path(@job, @applicant)
    else
      set_collections
      redirect_to freelancer_job_application_index_path(@job, @applicant)
    end
  end

  private

  def set_job
    # @job = current_freelancer.applicants.includes(applicants: [:quotes, :messages]).  find(params[:job_id])
    @job = current_user.applicants.where({job_id: params[:job_id] }).first.job
  end

  def set_applicant
    set_job
    if params[:applicant_id]
      @applicant = @job.applicants.find(params[:applicant_id])
    else
      @applicant = @job.applicants.without_state(:ignored).includes(:messages).order("messages.created_at").where({ freelancer_id: current_user.id }).first
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
