class Freelancer::PaymentsController < Freelancer::BaseController

  def index
    @jobs = current_user.jobs.order(created_at: :desc).page(params[:page]).per(50)
  end

end
