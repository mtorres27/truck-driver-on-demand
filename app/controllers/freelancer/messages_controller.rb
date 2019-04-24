class Freelancer::MessagesController < Freelancer::BaseController
  before_action :authorize_freelancer
  before_action :set_company

  def index
    set_collection
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