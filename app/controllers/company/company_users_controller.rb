class Company::CompanyUsersController < Company::BaseController
  before_action :find_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = current_company.company_users
  end

  def show
  end

  def new
    @company_user = current_company.company_users.new
    @roles = Roleable::COMPANY_ROLES.map { |r| r.to_s.humanize }
  end

  def create
    if CompanyUser.invite!(company_user_params.merge({company_id: current_company.id}))
      redirect_to company_company_users_path(current_company)
    else
      render 'new'
    end
  end

  def edit
    @roles = Roleable::COMPANY_ROLES.map { |r| r.to_s.humanize }
  end

  def update
    if @company_user.update(company_user_params)
      if current_user.id == @company_user.id
        redirect_to new_user_session_path
      else
        redirect_to company_company_users_path(current_company)
      end
    else
      render 'edit'
    end
  end

  def destroy
    @company_user.destroy

    redirect_to company_company_users_path(current_company)
  end

  private

  def find_user
    @company_user = current_company.company_users.find(params[:id])
  end

  def company_user_params
    params.require(:company_user).permit(
      :first_name, :last_name, :email, :role, :password, :password_confirmation
    )
  end
end
