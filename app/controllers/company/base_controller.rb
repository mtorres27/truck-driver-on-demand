class Company::BaseController < ApplicationController
  layout 'company/layouts/application'

  before_action :authenticate_user!
  before_action :redirect_if_not_company

  helper_method :current_company

  private

  def current_company
    @current_company ||= current_user&.company
  end

  def redirect_if_not_company
    redirect_to root_path if current_company.nil?
  end

  def current_company_registering?
    !current_company.registration_completed?
  end

end
