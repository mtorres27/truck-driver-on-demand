class Admin::NewRegistrantsController < Admin::BaseController

  def index
    freelancers = Freelancer.where(disabled: true)
    companies = Company.where(disabled: true)
    @new_registrants = (freelancers + companies).sort_by { |registrant| registrant.name }
  end
end