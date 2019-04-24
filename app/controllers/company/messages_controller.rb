class Company::MessagesController < Company::BaseController
  before_action :authorize_company
  before_action :set_freelancer

  def index
    set_collection
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