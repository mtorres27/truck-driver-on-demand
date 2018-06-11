class Admin::NewRegistrantsController < Admin::BaseController

  def index
    freelancers = FreelancerData.where(disabled: true)
    companies = CompanyData.where(disabled: true)
    @new_registrants = (freelancers + companies).sort_by { |registrant| registrant.created_at }.reverse
  end
end