class Company::MainController < Company::BaseController

  before_action :redirect_to_registration_step, if: :current_company_registering?

  def index
    authorize current_company
    # @freelancers = Freelancer.where(disabled: false).order(id: 'DESC').limit(4)
    @freelancers ||= []
    begin
      @freelancers = Freelancer.find([335, 229, 320, 393])
    rescue Exception

    end
  end

  private

  def redirect_to_registration_step
    return if current_company.registration_completed?

    redirect_to company_registration_step_path(current_company.registration_step)
  end

end
