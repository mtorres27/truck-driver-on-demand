class Company::ReviewsController < Company::BaseController
  before_action :set_job
  before_action :set_review, only: [:show, :edit, :update]

  def new
    @freelancer_review = @job.build_freelancer_review
  end

  def create
    @freelancer_review = @job.build_freelancer_review(review_params)

    if @freelancer_review.save
      redirect_to company_job_review_path(@job)
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @freelancer_review.update(review_params)
      redirect_to company_job_review_path(@job)
    else
      render :edit
    end
  end

  private

    def set_job
      @job = current_company.jobs.find(params[:job_id])
    end

    def set_review
      @freelancer_review = @job.freelancer_review
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
