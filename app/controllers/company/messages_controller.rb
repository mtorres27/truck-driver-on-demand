class Company::MessagesController < Company::BaseController
  before_action :authorize_company
  before_action :set_freelancer

  def index
    set_collection
    if params[:job_id] == 'profile'
      @job_or_profile = 'profile'
    elsif params[:job_id].present? && @messages.select { |msg| msg.job_id == params[:job_id].to_i }.count == 0
      @job_or_profile = Job.find(params[:job_id])
    end
    current_company.notifications.where(authorable: @freelancer).each do |notification|
      notification.mark_as_read
    end
  end

  private

  def authorize_company
    authorize current_company
  end

  def set_freelancer
    @freelancer = Freelancer.find(params[:freelancer_id])
  end

  def set_collection
    @messages = current_company.messages_for_freelancer(@freelancer)
  end
end