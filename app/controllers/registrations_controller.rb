class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    if resource.is_a?(Freelancer)
      freelancer_registration_steps_path
    elsif resource.is_a?(Company)
      company_registration_steps_path
    else
      super
    end
  end

  def after_inactive_sign_up_path_for(resource)
    cookies.delete(:onboarding)
    "/confirm_email"
  end
end
