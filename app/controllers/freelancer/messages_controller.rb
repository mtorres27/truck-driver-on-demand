class Freelancer::MessagesController < Freelancer::BaseController
  before_action :set_job

  def index
    set_collection
  end

  def create
    @message = @job.messages.new(message_params)
    @message.authorable = current_freelancer

    if @message.save
      redirect_to freelancer_job_messages_path(@job)
    else
      set_collection
      render :show
    end
  end

  private

  def set_job
    @job = current_freelancer.jobs.includes(messages: :authorable).find(params[:job_id])
  end

  def set_collection
    @messages = @job.messages
  end

  def message_params
    params.require(:message).permit(:body, :attachment, :checkin)
  end
end