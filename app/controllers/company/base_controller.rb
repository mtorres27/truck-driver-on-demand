class Company::BaseController < ApplicationController
  layout 'company/layouts/application'

  before_action :authenticate_user!
  before_action :redirect_if_not_company
  before_action :redirect_if_not_subscribed

  helper_method :current_company

  private

  def current_company
    @current_company ||= current_user&.try(:company)
  end

  def redirect_if_not_company
    redirect_to root_path if current_company.nil?
  end

  def redirect_if_not_subscribed
    redirect_to root_path if unsubscribed_redirect?
  end

  def current_company_registering?
    !current_company.registration_completed?
  end

  def unsubscribed_redirect?
    !current_company&.subscription_active?
  end
end
