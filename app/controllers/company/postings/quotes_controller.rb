class Company::Postings::QuotesController < Company::BaseController
  before_action :set_applicant

  def index
    @quote = @applicant.quotes.new
  end

  def create
    @quote = @applicant.quotes.new(quote_params)

    if @quote.save
      redirect_to company_applicant_quotes_path(@applicant), notice: "Quote created."
    else
      render :index
    end
  end

  def decline
    @quote.decline!
    redirect_to company_postings_job_applicants_path(@applicant.job), notice: "Quote declined."
  end

  private

    def set_applicant
      @applicant = Applicant.includes(job: :project).find(params[:applicant_id])
      unless @applicant.job.project.company_id == current_company.id
        redirect_back fallback_location: company_postings_projects_path, error: "Invalid applicant selected."
      end
    end

    def quote_params
      params.require(:quote).permit(
        :amount,
        :declined,
        :body,
        :attachment_data
      )
    end
end
