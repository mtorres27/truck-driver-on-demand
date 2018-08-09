class Admin::NewRegistrantsController < Admin::BaseController

  def index
    authorize current_user
    freelancers = FreelancerProfile.where(disabled: true)
    companies = Company.where(disabled: true)
    @new_registrants = (freelancers + companies).sort_by { |registrant| registrant.created_at }.reverse
  end
end
