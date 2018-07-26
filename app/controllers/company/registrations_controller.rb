class Company::RegistrationsController < Devise::RegistrationsController

  before_action :configure_permitted_parameters

  def create
    super do |resource|
      resource.add_valid_role :owner
      sign_in resource if resource.valid?
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :accept_terms_of_service])
  end

  def after_sign_up_path_for(resource)
    company_registration_steps_path
  end

  def after_sign_in_path_for(resource)
    company_root_path
  end

  def after_inactive_sign_up_path_for(resource)
    cookies.delete(:onboarding)
    confirm_email_path
  end

end
