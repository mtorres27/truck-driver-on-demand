class Freelancer::MainController < Freelancer::BaseController

  before_action :redirect_to_registration_step, if: :current_freelancer_registering?

  def index
    authorize current_user
    # @companies =  Company.where(:disabled => false).order(id: 'DESC').limit(4)
    # @companies = Company.find([67, 13, 64, 59]);
    @companies ||= []
    begin
      @companies = Company.find([67, 13, 64, 59]);
    rescue Exception
    end
  end

  private

  def redirect_to_registration_step
    return if current_user.registration_completed?

    redirect_to freelancer_registration_step_path(current_user.freelancer_profile&.registration_step)
  end
end
