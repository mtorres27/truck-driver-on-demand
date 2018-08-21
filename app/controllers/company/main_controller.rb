class Company::MainController < Company::BaseController

  before_action :redirect_to_registration_step, if: :current_company_registering?

  def index
    authorize current_company
    @freelancers = Freelancer.joins(:freelancer_profile).where(freelancer_profiles: { disabled: false }).where('freelancer_profiles.profile_score > 15').order(created_at: 'DESC').limit(4)
  end

  private

  def redirect_to_registration_step
    return if current_company.registration_completed?

    redirect_to company_registration_step_path(current_company.registration_step)
  end

end
