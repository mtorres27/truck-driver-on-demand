class SessionsController < Devise::SessionsController
  before_action :set_currently_logged_in, only: :destroy

  def new
    super
  end

  def create
    super
  end

  def destroy
    super
  end

  private

  def set_currently_logged_in
    current_user.update_attribute(:currently_logged_in, false)
  end
end
