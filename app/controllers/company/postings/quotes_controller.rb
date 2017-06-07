class Company::Postings::QuotesController < Company::BaseController
  before_action :set_job
  before_action :set_applicant

  def index
    @quotes = @applicant.quotes
    @quote = @quotes.new
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
      @applicant = @job.applicants.includes(:quotes).find(params[:applicant_id])
    end

    def quote_params
      params.require(:quote).permit(
        :amount,
        :state,
        :body,
        :attachment_data
      )
    end
end
