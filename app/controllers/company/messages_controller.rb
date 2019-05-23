class Company::MessagesController < Company::BaseController
  before_action :authorize_company
  before_action :set_freelancer

  def index
    set_collection
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