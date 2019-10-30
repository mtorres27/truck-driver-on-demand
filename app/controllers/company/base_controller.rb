# frozen_string_literal: true

class Company::BaseController < ApplicationController

  layout "company/layouts/application"

  before_action :authenticate_user!
  before_action :redirect_if_not_company
  before_action :redirect_if_disabled

  helper_method :current_company

  private

  def current_company
    @current_company ||= current_user&.try(:company)
  end

  def redirect_if_not_company
    redirect_to root_path if current_company.nil?
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

end
