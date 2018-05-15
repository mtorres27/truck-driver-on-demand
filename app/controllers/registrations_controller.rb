class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    (super && return) unless resource.is_a?(Freelancer)
    freelancer_registration_steps_path
  end

  def after_inactive_sign_up_path_for(resource)
    cookies.delete(:onboarding)
    "/confirm_email"
  end
end
