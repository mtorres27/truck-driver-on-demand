class Company::CompanyUsersController < Company::BaseController

  before_action :set_company_user, only: [:show, :edit, :update, :destroy, :disable, :enable]

  def index
    authorize current_user
    @users = current_company.company_users
  end

  def show
    authorize @company_user
  end

  def new
    @company_user = current_company.company_users.new
    authorize @company_user
  end

  def create
    @company_user = current_company.company_users.new(company_user_params)
    authorize @company_user
    generated_password = Devise.friendly_token.first(8)
    @company_user.password = generated_password
    @company_user.role = "Manager"
    if @company_user.save
      @company_user.confirm
      CompanyMailer.welcome_new_company_user(@company_user, generated_password).deliver_later
      flash[:notice] = "An invite was successfully sent to #{@company_user.email} to join your team."
      redirect_to company_company_users_path
    else
      flash.now[:error] = @company_user.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    authorize @company_user
  end

  def update
    authorize @company_user
    params[:company_user] = params[:company_user].except(:password, :password_confirmation) if params[:company_user][:password].blank?
    if @company_user.update(company_user_params)
      if @company_user == current_user
        bypass_sign_in(@company_user)
      end
      if !params[:company_user][:password].blank?
        flash[:notice] = "Password successfully updated"
      else
        flash[:notice] = "Successfully updated"
      end
      if @company_user == current_user
        redirect_to edit_company_company_user_path(@company_user)
      else
        redirect_to edit_company_company_users_path
      end
    else
      flash.now[:error] = @company_user.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    authorize @company_user
    if @company_user.destroy
      flash[:notice] = "User deleted"
    else
      flash[:notice] = "There was an error trying to delete the user"
    end
    redirect_to company_company_users_path
  end

  def disable
    authorize @company_user
    if @company_user.update_attribute(:enabled, false)
      flash[:notice] = "User disabled"
    else
      flash[:notice] = "There was an error trying to disable the user"
    end
    redirect_to company_company_users_path
  end

  def enable
    authorize @company_user
    if @company_user.update_attribute(:enabled, true)
      flash[:notice] = "User enabled"
    else
      flash[:error] = "There was an error trying to enable the user"
    end
    redirect_to company_company_users_path
  end

  private

  def set_company_user
    @company_user = current_company.company_users.find(params[:id])
  end

  def company_user_params
    params.require(:company_user).permit(
        :first_name,
        :last_name,
        :email,
        :phone_number,
        :password,
        :password_confirmation
    )
  end
end
