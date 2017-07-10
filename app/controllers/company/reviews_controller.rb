class Company::ReviewsController < Company::BaseController
  before_action :set_job
  before_action :set_review, only: [:show, :edit, :update]

  def new
    @review = @job.review.new
  end

  def create
    @review = @job.review.new(review_params)

    if @review.save
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
    if @review.update(review_params)
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
      @review = @job.review
    end

    def review_params
      params.require(:review).permit(:rating, :body)
    end
end
