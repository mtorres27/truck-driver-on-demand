class Company::ReviewsController < Company::BaseController
  before_action :set_job

  def show
    @review =
      @job.freelancer_review ||
      @job.build_freelancer_review

    @review.freelancer = @job.freelancer
    @review.company = current_user
  end

  def create
    @review = @job.build_freelancer_review(review_params)
    @review.freelancer = @job.freelancer
    @review.company = current_user

    if @review.save
      FreelancerMailer.notice_company_review(current_user, @job.freelancer, @review).deliver_later
      redirect_to company_job_review_path(@job)
    else
      render :show
    end
  end

  private

    def set_job
      @job = current_user.jobs.find(params[:job_id])
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
