class Company::QuotesController < Company::BaseController
  before_action :set_applicant
  before_action :set_quote, only: [:accept, :decline]

  def index
    set_collections
  end

  def create
    @message = @applicant.messages.new(message_params)
    @message.authorable = current_company

    if @message.save
      redirect_to company_job_applicant_quotes_path(@job, @applicant)
    else
      set_collections
      render :index
    end
  end

  def accept
    @quote.accept!
    redirect_to company_job_applicant_quotes_path(@job, @applicant)
  end

  def decline
    @quote.decline!
    redirect_to company_job_applicant_quotes_path(@job, @applicant)
  end

  private

    def set_job
      @job = current_company.jobs.includes(applicants: [:quotes, :messages]).find(params[:job_id])
    end

    def set_applicant
      set_job
      @applicant = @job.applicants.find(params[:applicant_id])
    end

    def set_quote
      @quote = @applicant.quotes.find(params[:id])
    end

    def set_collections
      @messages = @applicant.messages
      @quotes = @applicant.quotes
    end

    def message_params
      params.require(:message).permit(:body, :attachment)
    end
end
