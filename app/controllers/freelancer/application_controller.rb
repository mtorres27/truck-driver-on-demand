class Freelancer::ApplicationController < Freelancer::BaseController
  before_action :set_job
  before_action :set_applicant
  before_action :authorize_freelancer

  def index
    set_collections
  end

  private

  def set_job
    @job = current_user.applicants.where({job_id: params[:job_id] }).first.job
  end


  def set_applicant
    @applicant = @job.applicants.where({ freelancer_id: current_user.id }).first
  end

  def authorize_freelancer
    authorize current_user
  end
  
  def set_collections
    @messages = @applicant.messages
    @quotes = @applicant.quotes
    @all_quotes = @applicant.job.quotes

    @combined_items = []
    @harmonized_items = []
    @harmonized_indices = []

    if @applicant and @applicant.job.applicants.where({state: "accepted"}).first == @applicant
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