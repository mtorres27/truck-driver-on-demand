class Freelancer::RegistrationStepsController < ApplicationController
  include Wicked::Wizard

  steps :personal, :job_info, :profile

  def show
    @freelancer = current_freelancer
    render_wizard
  end

  def index
    redirect_to freelancer_registration_step_path(:personal)
  end

  def update
    @freelancer = current_freelancer
    @freelancer.attributes = params[:freelancer] ? freelancer_params : {}
    @freelancer.registration_step = next_step

    sign_out @freelancer if next_step == "wicked_finish" && profile_form_filled?

    render_wizard @freelancer
  end

  def skip
    @freelancer = current_freelancer
    @freelancer.update_attribute(:registration_step, next_step)
    sign_out @freelancer if next_step == "wicked_finish"
    redirect_to freelancer_registration_step_path(next_step)
  end

  private

  def finish_wizard_path
    confirm_email_path
  end

  def profile_form_filled?
    current_freelancer.avatar.present? &&
    current_freelancer.bio.present? &&
    current_freelancer.tagline.present?
  end

  def freelancer_params
    params.require(:freelancer).permit(
      :first_name,
      :last_name,
      :city,
      :company_name,
      :country,
      :state,
      :avatar,
      :bio,
      :tagline,
      job_types: I18n.t("enumerize.job_types").keys,
      job_markets: (I18n.t("enumerize.live_events_staging_and_rental_job_markets").keys + I18n.t("enumerize.system_integration_job_markets").keys).uniq,
      job_functions: (I18n.t("enumerize.system_integration_job_functions").keys + I18n.t("enumerize.live_events_staging_and_rental_job_functions").keys).uniq,
    )
  end

end
