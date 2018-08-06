class Company::UsersController < Company::BaseController
  def index
    @users = current_company.company_users
  end
end
