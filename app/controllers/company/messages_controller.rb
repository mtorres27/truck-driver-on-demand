class Company::MessagesController < Company::BaseController
  before_action :set_job

  def index
    @messages = @job.messages.order(created_at: :desc)
  end

end
