class Admin::MainController < Admin::BaseController
  def index
    authorize current_user
  end
end
