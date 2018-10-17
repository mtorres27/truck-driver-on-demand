class Company::MainController < Company::BaseController

  before_action :redirect_to_registration_step, if: :current_company_registering?

  def index
    authorize current_company
    @freelancers = Freelancer.joins(:freelancer_profile).where(freelancer_profiles: { disabled: false }).where('freelancer_profiles.profile_score > 15').order(created_at: 'DESC').limit(4)
    if current_company.canada_country?
      @plans = Plan.where(is_canadian: true)
    else
      @plans = Plan.where(is_canadian: false)
    end
  end

  private

  def redirect_to_registration_step
    return if current_company.registration_completed?

    redirect_to company_registration_step_path(current_company.registration_step)
  end

  def unsubscribed_redirect?
    false
  end

end
