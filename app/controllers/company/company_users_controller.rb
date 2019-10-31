# frozen_string_literal: true

class Company::CompanyUsersController < Company::BaseController

  before_action :set_company_user, only: %i[edit update]

  def edit
    authorize @company_user
  end

  def update
    authorize @company_user
    if params[:company_user][:password].blank? || params[:company_user][:password_confirmation].blank?
      params[:company_user] = params[:company_user].except(:password, :password_confirmation)
    end
    if @company_user.update(company_user_params)
      bypass_sign_in(@company_user) if @company_user == current_user
      flash[:notice] = if !params[:company_user][:password].blank?
                         "Password successfully updated"
                       else
                         "Successfully updated"
                       end
      redirect_to company_profile_path
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
      :password_confirmation,
    )
  end

end
