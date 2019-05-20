class Freelancer::RegistrationStepsController < Freelancer::BaseController
  include Wicked::Wizard

  skip_before_action :authenticate_user!, only: [:show]
  skip_before_action :redirect_if_not_freelancer, only: [:show]

  steps :personal, :job_info

  rescue_from Wicked::Wizard::InvalidStepError do
    redirect_to new_user_session_path
  end

  def show
    if params[:id] == "wicked_finish" || current_freelancer_profile&.registration_step == "wicked_finish"
      redirect_to finish_wizard_path
    elsif current_freelancer_profile.nil?
      redirect_to root_path
    else
      render_wizard
    end
  end

  def index
    redirect_to freelancer_registration_step_path(:personal)
  end

  def update
    current_freelancer_profile.attributes = params[:freelancer_profile].present? ? freelancer_profile_params : {}
    current_freelancer_profile.registration_step = next_step

    sign_out current_user if next_step == "wicked_finish"

    render_wizard current_freelancer_profile
  end

  def previous
    current_freelancer_profile.update(registration_step: previous_step)
    redirect_to freelancer_registration_step_path(previous_step)
  end

  private

  def finish_wizard_path
    confirm_email_path
  end

  def freelancer_profile_params
    params.require(:freelancer_profile).permit(
      :city,
      :company_name,
      :country,
      :state,
      :avatar,
      :bio,
      :tagline,
      :phone_number,
      :service_areas,
      job_markets: (I18n.t("enumerize.live_events_staging_and_rental_job_markets").keys + I18n.t("enumerize.system_integration_job_markets").keys).uniq,
      job_functions: (I18n.t("enumerize.system_integration_job_functions").keys + I18n.t("enumerize.live_events_staging_and_rental_job_functions").keys).uniq
    )
  end

  def verify_current_freelancer
    return if current_user.freelancer?
    redirect_to new_freelancer_session_path
  end
end
