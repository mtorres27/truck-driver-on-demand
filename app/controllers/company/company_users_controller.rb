class Company::CompanyUsersController < Company::BaseController
  def index
    @users = current_company.company_users
  end

  def show
  end

  def new
    @company_user = current_company.company_users.new
  end

  def create
    @company_user = current_company.company_users.new(company_user_params)
    binding.pry
  end

  def edit
  end

  def update
  end

  def delete
  end

  private

  def find_user
    @company_user = current_company.company_users.find(params[:id])
  end

  def company_user_params
  end
end
