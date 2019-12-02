# frozen_string_literal: true

class Driver::RegistrationsController < Devise::RegistrationsController

  # layout 'clean'

  before_action :configure_permitted_parameters

  def create
    params["driver"]["password_confirmation"] = params["driver"]["password"]
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

end
