class Company::RegistrationStepsController < ApplicationController
  include Wicked::Wizard
  steps :personal, :job_info, :profile

  def show
    @company = current_company
    render_wizard
  end

  def index
    redirect_to company_registration_step_path(:personal)
  end

  def update
    @company = current_company
    @company.attributes = params[:company] ? company_params : {}
    @company.registration_step = next_step

    sign_out @company if next_step == "wicked_finish" && @company.profile_form_filled?

    render_wizard @company
  end

  def skip
    @company = current_company
    @company.update_attribute(:registration_step, next_step)
    sign_out @company if next_step == "wicked_finish"
    redirect_to company_registration_step_path(next_step)
  end

private

  def finish_wizard_path
    confirm_email_path
  end

  def company_params
    params.require(:company).permit(
      :first_name,
      :last_name,
      :city,
      :name,
      :country,
      :state,
      :avatar,
      :description,
      :established_in,
      :number_of_employees,
      :number_of_offices,
      :website,
      :area,
      job_types: I18n.t("enumerize.job_types").keys,
      job_markets: (I18n.t("enumerize.live_events_staging_and_rental_job_markets").keys + I18n.t("enumerize.system_integration_job_markets").keys).uniq,
    )
  end
end
