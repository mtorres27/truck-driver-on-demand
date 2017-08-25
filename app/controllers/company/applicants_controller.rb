class Company::ApplicantsController < Company::BaseController
  before_action :set_job
  before_action :set_applicant, except: [:index]

  def index
    @applicants = @job.applicants.includes(:quotes, :freelancer).without_state(:ignored).order(created_at: :desc)
    if params[:filter].presence
      @applicants = @applicants.where({state: params[:filter]})
    end

    set_job

    if @job.applicants.where({state: "accepted"}).length > 0
      @applicant = @job.applicants.where({state: "accepted"}).first
      @current_applicant_id = @applicant.id
    else
      if @job.applicants.length > 0
        @applicant = Applicant.where({job_id:@job.id}).includes(:messages).order("messages.created_at").where('messages_count > 0').last
        @current_applicant_id = @applicant.id
      else
        @applicant = nil
        @current_applicant_id = nil
      end
    end

    set_collections
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

    def set_collections
      if @applicant
        @messages = @applicant.messages
        @quotes = @applicant.quotes
        @all_quotes = @applicant.job.quotes
      else
        @messages = []
        @quotes = []
        @all_quotes = []
      end
      @combined_items = []
      @harmonized_items = []
      @harmonized_indices = []

      if @applicant and @applicant.job.applicants.where({state: "accepted"}).length > 0
        @applicant_accepted = true
      else
        @applicant_accepted = false
      end

      @messages.each do |message|
        @combined_items.push({ type: "message", payload: message, date: message.created_at.to_i })
        @harmonized_indices.push(message.created_at.to_i)
      end

      @quotes.each do |quote|
        @combined_items.push({ type: "quote", payload: quote, date: quote.created_at.to_i })
        @harmonized_indices.push(quote.created_at.to_i)
      end

      @harmonized_indices = @harmonized_indices.sort.reverse()

      @harmonized_indices.each do |index|
        search_in_combined(@combined_items, index)
      end

      if params[:filter].presence
        @applicants = @applicants.where({state: params[:filter]})
      end
    end

    def search_in_combined(haystack, needle)
      index = 0
      haystack.each do |item|
        if needle == item[:date]
          @harmonized_items.push(item)
          haystack.delete_at(index)
          return
        end
        index += 1
      end
    end
end
