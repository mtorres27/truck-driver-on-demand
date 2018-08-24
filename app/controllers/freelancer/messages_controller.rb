class Freelancer::MessagesController < Freelancer::BaseController
  before_action :set_job
  before_action :authorize_job

  def index
    set_collection
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
end