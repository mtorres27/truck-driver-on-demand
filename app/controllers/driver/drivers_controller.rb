# frozen_string_literal: true

class Driver::DriversController < Driver::BaseController

  def show
    authorize current_user
  end

  def edit
    authorize current_user
  end

  def update
    authorize current_user
  end

  def request_verification
    DriverMailer.request_profile_verification(current_user).deliver_later
    current_user.driver_profile.update_column(:requested_verification, true)
    redirect_to driver_profile_path
  end

end
