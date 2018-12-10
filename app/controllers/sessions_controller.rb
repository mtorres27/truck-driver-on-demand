class SessionsController < Devise::SessionsController
  before_action :set_currently_logged_in_false, only: :destroy
  after_action :set_currently_logged_in_true, only: :create

  def new
    super
  end

  def create
    reset_session
    super
  end

  def destroy
    super
  end

  def active
    render_session_status
  end

  def timeout
    flash[:notice] = "Your session has timed out."
    redirect_to root_path
  end

  private

  def set_currently_logged_in_false
    current_user.update_attribute(:currently_logged_in, false)
  end

  def set_currently_logged_in_true
    current_user.update_attribute(:currently_logged_in, true)
  end
end
