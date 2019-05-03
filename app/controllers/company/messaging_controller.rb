class Company::MessagingController < Company::BaseController
  before_action :authorize_company
  before_action :set_freelancers

  def index; end

  private

  def authorize_company
    authorize current_company
  end

  def set_freelancers
    @freelancers = current_company.freelancers_for_messaging
  end
end