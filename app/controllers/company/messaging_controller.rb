# frozen_string_literal: true

class Company::MessagingController < Company::BaseController

  before_action :authorize_company
  before_action :set_drivers

  def index; end

  private

  def authorize_company
    authorize current_company
  end

  def set_drivers
    @drivers = current_company.drivers_for_messaging
  end

end
