# frozen_string_literal: true

class Driver::RegistrationStepsController < Driver::BaseController

  include Wicked::Wizard

  skip_before_action :authenticate_user!, only: [:show]

  steps :confirm_phone

  rescue_from Wicked::Wizard::InvalidStepError do
    redirect_to root_path
  end

  def show
    if params[:id] == "wicked_finish" || current_driver_profile&.registration_step == "wicked_finish"
      redirect_to finish_wizard_path
    elsif current_driver_profile.nil?
      redirect_to root_path
    else
      current_user.send_login_code
      DriverMailer.send_confirmation_code(current_user, current_user.login_code).deliver_later
      render_wizard
    end
  end

  def index
    redirect_to driver_registration_step_path(:confirm_phone)
  end

  def update
    if current_user.login_code == params[:driver][:login_code]
      current_driver_profile.registration_step = next_step
      render_wizard current_driver_profile
    else
      flash[:error] = "Wrong code. Please try again."
      render_wizard current_driver_profile
    end
  end

  private

  def finish_wizard_path
    driver_root_path
  end

  def company_params
    params.require(:company).permit(
      :name,
      :city,
      :state,
      :country,
      :website,
      :area,
      :phone_number,
      # rubocop:disable Metrics/LineLength
      job_markets: (I18n.t("enumerize.live_events_staging_and_rental_job_markets").keys + I18n.t("enumerize.system_integration_job_markets").keys).uniq,
      # rubocop:enable Metrics/LineLength
    )
  end

end
