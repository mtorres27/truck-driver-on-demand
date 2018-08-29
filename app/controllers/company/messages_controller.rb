class Company::MessagesController < Company::BaseController
  before_action :set_job
  before_action :authorize_job

  def index
    set_collection
  end

  private

  def set_job
    @job = current_company.jobs.includes(messages: :authorable).find(params[:job_id])
  end

  def authorize_job
    authorize @job
  end

  def set_collection
    @messages = @job.messages
  end
end