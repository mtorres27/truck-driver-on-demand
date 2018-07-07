class Freelancer::BankingsController < Freelancer::BaseController
  def edit
    authorize current_user
  end

  def update
    authorize current_user
  end
end