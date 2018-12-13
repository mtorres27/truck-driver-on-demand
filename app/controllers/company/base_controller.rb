class Company::BaseController < ApplicationController
  layout 'company/layouts/application'

  before_action :authenticate_user!
  before_action :redirect_if_not_company
  before_action :redirect_if_not_subscribed
  before_action :redirect_if_disabled

  helper_method :current_company

  private

  def check_for_job_posting_availability
    if current_company.present? && current_company.plan.present? && !current_company.has_available_job_posting_slots?
      flash[:job_posting_limit] = "You have reached the job posting limit for your current subscription, future jobs will be saved as a drafts. You need to disable a job or open a contract with a freelancer on one of your current jobs, or upgrade to a higher plan in order to publish another job."
    end
  end

  def current_company
    @current_company ||= current_user&.try(:company)
  end

  def redirect_if_not_company
    redirect_to root_path if current_company.nil?
  end

  def redirect_if_not_subscribed
    redirect_to root_path if unsubscribed_redirect?
  end

  def redirect_if_disabled
    return if (current_user.present? && current_user.enabled) || !current_user.present?
    sign_out current_user
    flash[:error] = "Your account has been disabled"
    redirect_to root_path
  end

  def current_company_registering?
    !current_company.registration_completed?
  end

  def unsubscribed_redirect?
    !current_company&.subscription_active?
  end
end
