class Company::MessagesController < Company::BaseController
  before_action :set_job

  def index
    @job.messages.each do |m|
      m.unread = false
      m.save
    end

    set_collection
  end

  def create
    @message = @job.messages.new(message_params)
    @message.authorable = current_company

    if @message.save
      redirect_to company_job_messages_path(@job)
    else
      set_collection
      render :show
    end
  end

  private

    def set_job
      @job = current_company.jobs.includes(messages: :authorable).find(params[:job_id])
    end

    def set_collection
      @messages = @job.messages
    end

    def message_params
      params.require(:message).permit(:body, :attachment)
    end
end
