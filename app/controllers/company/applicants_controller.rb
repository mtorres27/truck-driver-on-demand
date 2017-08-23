class Company::ApplicantsController < Company::BaseController
  before_action :set_job
  before_action :set_applicant, except: [:index]

  def index
    @applicants = @job.applicants.includes(:quotes, :freelancer).without_state(:ignored).order(created_at: :desc)
    @current_applicant_id = nil
  end

  def request_quote
    @applicant.request_quote!
    redirect_to company_job_applicants_path(@job), notice: "Quote requested from #{@applicant.freelancer&.name}"
  end

  def ignore
    @applicant.ignore!
    redirect_to company_job_applicants_path(@job), notice: "Applicant #{@applicant.freelancer&.name} ignored"
  end

  private

    def set_job
      @job = current_company.jobs.includes(:applicants).find(params[:job_id])
    end

    def set_applicant
      @applicant = @job.applicants.find(params[:id])
    end
end
