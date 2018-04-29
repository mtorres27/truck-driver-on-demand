class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    if resource.class.name == "Freelancer"
      freelancer_registration_step_path(:personal)
    end
  end
end
