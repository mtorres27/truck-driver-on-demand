class Freelancer::ReviewsController < Company::BaseController
  before_action :set_job

  def show
    @review =
      @job.company_review ||
      @job.build_company_review
  end

  def create
    @review = @job.build_company_review(review_params)
    @review.company = @job.company
    @review.freelancer = current_freelancer

    if @review.save
      redirect_to freelancer_job_review_path(@job)
    else
      render :show
    end
  end

  private
    def set_job
      @job = Job.find(params[:job_id])
    end

    def review_params
      params.require(:company_review).permit(
        :quality_of_information_provided,
        :communication,
        :materials_available_onsite,
        :promptness_of_payment,
        :overall_experience,
        :comments
      )
    end
end
