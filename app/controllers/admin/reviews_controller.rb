class Admin::ReviewsController < Admin::BaseController
  before_action :set_job
  before_action :authorize_job

  def show
    @freelancer_review = @job.freelancer_review || @job.build_freelancer_review
    @company_review = @job.company_review || @job.build_company_review
  end

  private

  def set_job
    @job = Job.all.find(params[:job_id])
  end

  def authorize_job
    authorize @job
  end
end
