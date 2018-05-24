class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    return freelancer_registration_steps_path if resource.is_a?(Freelancer)
    (super && return) unless resource.is_a?(Company)
    company_registration_steps_path
  end

  def after_inactive_sign_up_path_for(resource)
    cookies.delete(:onboarding)
    "/confirm_email"
  end
end
