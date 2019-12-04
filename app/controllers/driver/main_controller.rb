# frozen_string_literal: true

class Driver::MainController < Driver::BaseController

  before_action :redirect_to_registration_step, if: :current_driver_registering?
  before_action :redirect_to_onboarding_process

  def index
    authorize current_user
    @jobs = Job.where(state: "published").order("created_at DESC")
  end

  private

  def redirect_to_registration_step
    return if current_user.registration_completed?

    redirect_to driver_registration_step_path(current_user.driver_profile&.registration_step)
  end

  def redirect_to_onboarding_process
    redirect_to driver_onboarding_process_index_path
  end

end
