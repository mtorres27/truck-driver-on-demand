# frozen_string_literal: true
class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  layout "admin"


  private

  def require_admin!
    raise ActiveRecord::RecordNotFound unless current_user.admin?
  end
end
