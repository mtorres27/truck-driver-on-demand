class Company::QuotesController < Company::BaseController
  before_action :set_quote

  def accept
    @quote.accept!
  end

  def decline
    @quote.decline!
  end

  private

    def set_quote
      @quote =
        Quote.
        join(applicant: :job).
        where(job: { company_id: current_company.id }).
        find(params[:id])
      # set_job
      # @applicant = @job.applicants.includes(:quotes).find(params[:applicant_id])
      # @quote = @applicant.quotes.find(params[:id])
    end
end
