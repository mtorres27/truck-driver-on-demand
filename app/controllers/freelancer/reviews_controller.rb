class Freelancer::ReviewsController < Freelancer::BaseController
  before_action :set_job
  before_action :authorize_job

  def show
    @review =
      @job.company_review ||
      @job.build_company_review
  end

  def create
    @review = @job.build_company_review(review_params)
    @review.company = @job.company
    @review.freelancer = current_user

    if @review.save
      Notification.create(title: @job.title, body: "#{current_user.first_name_and_initial} reviewed your performance on this job", authorable: @job.freelancer, receivable: @job.company, url: company_job_url(@job))
      CompanyMailer.notice_freelancer_review(@job.company, current_user, @review).deliver_later
      redirect_to freelancer_job_review_path(@job)
    else
      render :show
    end
  end

  private
  def set_job
    @job = Job.find(params[:job_id])
  end

  def authorize_job
    authorize @job
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
