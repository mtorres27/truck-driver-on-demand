# frozen_string_literal: true

class Company::MainController < Company::BaseController

  before_action :redirect_to_registration_step, if: :current_company_registering?

  def index
    authorize current_company
  end

  private

  def redirect_to_registration_step
    return if current_company.registration_completed?

    redirect_to company_registration_step_path(current_company.registration_step)
  end

end
