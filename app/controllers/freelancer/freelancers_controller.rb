class Freelancer::FreelancersController < Freelancer::BaseController

  def show
    authorize current_user
  end

  def edit
    authorize current_user
  end

  def update
    authorize current_user
  end

end
