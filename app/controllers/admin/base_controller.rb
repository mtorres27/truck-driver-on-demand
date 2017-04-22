# frozen_string_literal: true
class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!

  layout "admin"

  helper_method :current_admin
  helper_method :admin_signed_in?

  private

  def current_admin
    begin
      @current_admin ||= Admin.find(session[:admin_id]) if session[:admin_id]
    rescue Exception => e
      nil
    end
  end

  def admin_signed_in?
    return true if current_admin
  end

  def authenticate_admin!
    unless current_admin
      redirect_to new_session_path(section: "admin"), alert: "You must be logged in to access the admin section."
    end
  end
end
