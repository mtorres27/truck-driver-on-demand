class Company::Postings::ApplicantsController < Company::BaseController
  before_action :set_job
  before_action :set_applicant, except: [:index]

  def index
    @applicants = @job.applicants.without_state(:ignored).includes(:freelancer).order(created_at: :desc)
  end

  def request_quote
    @applicant.request_quote!
    redirect_to company_postings_job_applicants_path(@job), notice: "Quote requested from #{@applicant.freelancer&.name}"
  end

  def accept
    @applicant.accept!
    redirect_to company_postings_job_applicants_path(@job)
  end

  private

    def set_applicant
      @applicant = @job.applicants.find(params[:id])
    end
end
