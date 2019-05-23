class Freelancer::MessagesController < Freelancer::BaseController
  before_action :authorize_freelancer
  before_action :set_company

  def index
    set_collection
    @job = Job.find(params[:job_id]) if params[:job_id].present?
    current_user.notifications.where(authorable: @company).each do |notification|
      notification.mark_as_read
    end
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def authorize_freelancer
    authorize current_user
  end

  def set_collection
    @messages = current_user.messages_for_company(@company)
  end
end