class Company::Postings::ApplicantsController < Company::BaseController
  before_action :set_job
  before_action :set_applicant, only: [:request_quote, :accept]

  def index
    @applicants = @job.applicants.without_state(:ignored).includes(:freelancer).order(created_at: :desc)
  end

  def request_quote
  end

  def accept
  end

  private

    def set_applicant
      @job.applicants.find(params[:id])
    end
end
