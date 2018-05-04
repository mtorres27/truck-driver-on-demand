class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    return freelancer_registration_steps_path if resource.is_a?(Freelancer)
  end
end
