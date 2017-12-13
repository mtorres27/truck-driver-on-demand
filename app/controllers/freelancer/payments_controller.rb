class Freelancer::PaymentsController < Freelancer::BaseController

  def index
    @jobs =
      current_freelancer.
      jobs.
      # joins(jobs: :payments).
      # includes(jobs: :payments).
      order(created_at: :desc).
      page(params[:page]).
      per(50)
  end

end
