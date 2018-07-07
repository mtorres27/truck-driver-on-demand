class Freelancer::MessagesController < Freelancer::BaseController
  before_action :set_job
  before_action :authorize_job

  def index
    set_collection
  end

  def create
    @message = @job.messages.new(message_params)
    @message.authorable = current_user

    if @message.save
      FreelancerMailer.notice_message_sent(@job.company, current_user, @message).deliver_later
      CompanyMailer.notice_message_received(@job.company, current_user, @job, @message).deliver_later
      redirect_to freelancer_job_messages_path(@job)
    else
      set_collection
      render :show
    end
  end

  private

  def set_job
    @job = current_user.jobs.includes(applicants: [:messages]).find(params[:job_id])
  end

  def authorize_job
    authorize @job
  end

  def set_collection
    @messages = @job.messages
  end

  def message_params
    params.require(:message).permit(:body, :attachment, :checkin, :lat, :lng)
  end
end