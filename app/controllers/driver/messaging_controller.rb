# frozen_string_literal: true

class Driver::MessagingController < Driver::BaseController

  before_action :authorize_driver
  before_action :set_companies

  def index; end

  private

  def authorize_driver
    authorize current_user
  end

  def set_companies
    @companies = current_user.companies_for_messaging
  end

end
