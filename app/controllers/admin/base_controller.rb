class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!

  layout "admin"

  def current_user
    current_admin
  end
end
