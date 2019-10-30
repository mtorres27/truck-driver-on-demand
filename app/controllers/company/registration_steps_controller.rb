# frozen_string_literal: true

class Company::RegistrationStepsController < Company::BaseController

  include Wicked::Wizard

  skip_before_action :authenticate_user!, only: [:show]
  skip_before_action :redirect_if_not_company, only: [:show]

  steps :personal, :job_info

  rescue_from Wicked::Wizard::InvalidStepError do
    redirect_to new_user_session_path
  end

  def show
    if params[:id] == "wicked_finish" || current_company&.registration_step == "wicked_finish"
      redirect_to finish_wizard_path
    elsif current_company.nil?
      redirect_to root_path
    else
      render_wizard
    end
  end

  def index
    redirect_to company_registration_step_path(:personal)
  end

  def update
    current_company.attributes = params[:company] ? company_params : {}
    current_company.registration_step = next_step

    sign_out current_user if next_step == "wicked_finish"

    render_wizard current_company
  end

  def previous
    current_company.update(registration_step: previous_step)
    redirect_to company_registration_step_path(previous_step)
  end

  private

  def finish_wizard_path
    confirm_email_path
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
