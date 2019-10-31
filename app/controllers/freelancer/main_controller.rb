# frozen_string_literal: true

class Freelancer::MainController < Freelancer::BaseController

  before_action :redirect_to_registration_step, if: :current_freelancer_registering?

  def index
    authorize current_user
    @jobs = Job.where(state: "published").order("created_at DESC")
  end

  private

  def redirect_to_registration_step
    return if current_user.registration_completed?

    redirect_to freelancer_registration_step_path(current_user.freelancer_profile&.registration_step)
  end

end
