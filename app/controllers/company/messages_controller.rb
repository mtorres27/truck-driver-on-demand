class Company::MessagesController < Company::BaseController
  before_action :set_job

  def index
    @messages = @job.messages.order(created_at: :desc)
  end

  def new
  end

  def create
    @message = @job.messages.new(message_params)

    if @message.save
      redirect_to company_job_messages_path(@job), notice: "Message sent."
    else
      render :new
    end
  end

end
