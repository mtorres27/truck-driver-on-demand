# frozen_string_literal: true

class Driver::RegistrationsController < Devise::RegistrationsController

  # layout 'clean'
  skip_before_action :verify_authenticity_token, only: [:create]
  after_action :cors_set_access_control_headers, only: [:create]
  before_action :configure_permitted_parameters

  def create
    params["driver"]["password_confirmation"] = params["driver"]["password"]
    params["driver"]["accept_terms_of_service"] = "1" if params["driver"]["accept_terms_of_service"] == "on"
    super do |resource|
      sign_in resource if resource.valid?
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name phone_number city accept_terms_of_service])
  end

  def after_sign_up_path_for(_resource)
    driver_registration_steps_path
  end

  def after_sign_in_path_for(_resource)
    driver_root_path
  end

  def after_inactive_sign_up_path_for(_resource)
    cookies.delete(:onboarding)
    confirm_email_path
  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = "1728000"
  end

end
