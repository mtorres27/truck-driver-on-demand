# frozen_string_literal: true

class Driver::RegistrationStepsController < Driver::BaseController

  include Wicked::Wizard

  skip_before_action :authenticate_user!, only: [:show]
  skip_before_action :redirect_if_not_driver, only: [:show]

  steps :personal, :expertise

  rescue_from Wicked::Wizard::InvalidStepError do
    redirect_to new_user_session_path
  end

  def show
    if params[:id] == "wicked_finish" || current_driver_profile&.registration_step == "wicked_finish"
      redirect_to finish_wizard_path
    elsif current_driver_profile.nil?
      redirect_to root_path
    else
      render_wizard
    end
  end

  def index
    redirect_to driver_registration_step_path(:personal)
  end

  def update
    current_driver_profile.attributes = params[:driver_profile].present? ? driver_profile_params : {}
    current_driver_profile.registration_step = next_step

    sign_out current_user if next_step == "wicked_finish"

    render_wizard current_driver_profile
  end

  def previous
    current_driver_profile.update(registration_step: previous_step)
    redirect_to driver_registration_step_path(previous_step)
  end

  private

  def finish_wizard_path
    confirm_email_path
  end

  def driver_profile_params
    params.require(:driver_profile).permit(
      :driver_type,
      :license_class,
      :county,
      :province,
      :city,
      :service_areas,
      :transmission_and_speed,
      :freight_type,
      :other_skills,
    )
  end

  def verify_current_driver
    return if current_user.driver?

    redirect_to new_driver_session_path
  end

end
