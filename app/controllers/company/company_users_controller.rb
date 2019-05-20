class Company::CompanyUsersController < Company::BaseController

  before_action :set_company_user, only: [:edit, :update]

  def edit
    authorize @company_user
  end

  def update
    authorize @company_user
    params[:company_user] = params[:company_user].except(:password, :password_confirmation) if params[:company_user][:password].blank? || params[:company_user][:password_confirmation].blank?
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

  private

  def set_company_user
    @company_user = current_company.company_user
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
