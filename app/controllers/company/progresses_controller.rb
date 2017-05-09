class Company::ProgressesController < Company::BaseController
  before_action :set_job

  def show
    @job_messages = @job.messages.order(created_at: :desc)
  end

end
