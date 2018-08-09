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

    @combined_items = []
    @harmonized_items = []
    @harmonized_indices = []

    if @applicant and @applicant.job.applicants.where({state: "accepted"}).first == @applicant
      @applicant_accepted = true
    else
      @applicant_accepted = false
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