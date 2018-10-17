class Company::ReviewsController < Company::BaseController
  before_action :set_job
  before_action :authorize_job

  def show
    @review = @job.freelancer_review || @job.build_freelancer_review
    @review.freelancer = @job.freelancer
    @review.company = current_company
  end

  def create
    @review = @job.build_freelancer_review(review_params)
    @review.freelancer = @job.freelancer
    @review.company = current_company

    if @review.save
      Notification.create(title: @job.title, body: "#{@job.company.name} reviewed your performance on this job.", authorable: @job.company, receivable: @job.freelancer, url: freelancer_job_url(@job))
      FreelancerMailer.notice_company_review(current_company, @job.freelancer, @review).deliver_later
      redirect_to company_job_review_path(@job)
    else
      render :show
    end
  end

  private

  def unsubscribed_redirect?
    false
  end

  def set_job
    @job = current_company.jobs.find(params[:job_id])
  end

  def authorize_job
    authorize @job
  end

  def review_params
    params.require(:freelancer_review).permit(
      :availability,
      :communication,
      :adherence_to_schedule,
      :skill_and_quality_of_work,
      :overall_experience,
      :comments
    )
  end
end
