class Admin::MessagesController < Admin::BaseController
  before_action :set_job

  def index
    set_collection
  end

  private

  def set_job
    @job = Job.all.includes(messages: :authorable).find(params[:job_id])
  end

  def set_collection
    @messages = @job.messages
  end
end