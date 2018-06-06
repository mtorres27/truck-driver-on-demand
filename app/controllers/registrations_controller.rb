class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_in_path_for(resource)
    if resource.meta_type == 'Admin'
      admin_root_path
    elsif resource.meta_type == 'Freelancer'
      freelancer_root_path
    elsif resource.meta_type == 'Company'
      company_root_path
    end
  end

  def after_sign_up_path_for(resource)
    if resource.is_a?(Freelancer)
      freelancer_registration_steps_path
    elsif resource.is_a?(Company)
      company_registration_steps_path
    elsif resource.is_a?(Admin)
      admin_root_path
    end
  end

  def after_inactive_sign_up_path_for(resource)
    cookies.delete(:onboarding)
    "/confirm_email"
  end
end
