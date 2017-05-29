class Company::Postings::MessagesController < Company::BaseController
  before_action :set_job

  def index
    @message = @job.messages.new
    set_collection
  end

  def create
    @message = @job.messages.new(message_params)
    @message.authorable = current_company

    if @message.save
      redirect_to company_postings_job_messages_path(@job), notice: "Message sent."
    else
      set_collection
      render :index
    end
  end

  private

    def set_collection
      @messages = @job.messages.includes(:authorable).order(created_at: :desc)
    end

    def message_params
      params.require(:message).permit(:body, :attachment)
    end
end
