class Freelancer::SettingsController < Freelancer::BaseController
  def index
    authorize current_user
  end

  def edit
    authorize current_user
  end

  def update
    authorize current_user
  end
end