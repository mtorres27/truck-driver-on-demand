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
    render_wizard @freelancer
  end

  private

  def current_freelancer
    Freelancer.find(session[:step_freelancer_id])
  end

  def finish_wizard_path
    confirm_email_path
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
