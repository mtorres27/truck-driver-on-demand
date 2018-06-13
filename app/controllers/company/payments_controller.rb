class Company::PaymentsController < Company::BaseController

  def index
    @projects = current_user.projects.joins(jobs: :payments).includes(jobs: :payments).order(created_at: :desc).page(params[:page]).per(50)
  end

end
