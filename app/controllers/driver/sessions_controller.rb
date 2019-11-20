# frozen_string_literal: true

class Driver::SessionsController < SessionsController

  def new
    super
  end

  def create
    super
  end

  def destroy
    super
  end

  def phone_login
    @user = Driver.find_by(phone_number: params[:user][:phone_number])
    if @user.login_code == params[:user][:login_code]
      sign_in(@user)
      redirect_to root_path
    else
      flash[:notice] = "Incorrect confirmation code"
      redirect_to new_driver_session_path
    end
  end

  def send_login_code
    @user = Driver.find_by(phone_number: params[:phone_number])
    @user.send_login_code
  end

end
