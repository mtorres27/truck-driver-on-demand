class Freelancer::JobPaymentsController < Freelancer::BaseController
  def index
    @job = Job.find(params[:job_id])
  end
end