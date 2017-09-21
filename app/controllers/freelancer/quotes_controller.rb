class Freelancer::QuotesController < Freelancer::BaseController
  before_action :set_applicant

  def index
    set_collections
  end

  def create
    set_collections

    @message = @applicant.messages.new(message_params)
    @message.authorable = current_freelancer
    
    if @message.save
      if params[:message][:status] == "negotiate"
        # not sure what goes here.
        # either add a new quote, or add a counter offer somehow. NOT SURE.

        # decline previous quotes
        @quotes.each do |quote|
          quote.state = "declined"
          quote.save
        end

        if @quotes.count > 0
          @new_quote = @quotes.last.dup
        else
          @new_quote = Quote.new
        end
        
        @new_quote.amount = params[:message][:counter]
        @new_quote.state = "pending"
        @new_quote.save
        
        if @quotes.count == 0
          @applicant.quotes << @new_quote
        end

      end

      redirect_to freelancer_job_application_index_path(@job, @applicant)
    else
        
      p @message.errors.full_messages
      set_collections
      redirect_to freelancer_job_application_index_path(@job, @applicant)
    end
  end

  private

    def set_job
      @job = current_company.jobs.includes(applicants: [:quotes, :messages]).find(params[:job_id])
    end

    def set_applicant
      set_job
      if params[:applicant_id]
        @applicant = @job.applicants.find(params[:applicant_id])
      else
        @applicant = @job.applicants.without_state(:ignored).includes(:messages).order("messages.created_at").first
      end
    end

    def set_quote
      @quote = @applicant.quotes.find(params[:id])
    end

    def set_collections
      @messages = @applicant.messages
      @quotes = @applicant.quotes
      @all_quotes = @applicant.job.quotes
      @applicants = @applicant.job.applicants.without_state(:ignored)
      @combined_items = []
      @harmonized_items = []
      @harmonized_indices = []

      if @applicants.where({state: "accepted"}).length > 0
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

      @current_applicant_id = @applicant.id

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

    def message_params
      params.require(:message).permit(:body, :attachment)
    end
end
