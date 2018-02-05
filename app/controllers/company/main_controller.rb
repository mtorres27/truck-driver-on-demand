class Company::MainController < Company::BaseController

  def index
    @freelancers = Freelancer.where(disabled: false).order(id: 'DESC').limit(4)
  end

end
