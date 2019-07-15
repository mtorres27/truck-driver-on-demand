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

  def request_verification
    FreelancerMailer.request_profile_verification(current_user).deliver_later
    current_user.freelancer_profile.update_column(:requested_verification, true)
    redirect_to freelancer_profile_path
  end

end
