class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    sign_out(resource)
    if resource.is_a?(Freelancer)
      session[:step_freelancer_id] = resource.id
      return freelancer_registration_steps_path
    end
    super
  end

  def after_inactive_sign_up_path_for(resource)
    cookies.delete(:onboarding)
    "/confirm_email"
  end
end
