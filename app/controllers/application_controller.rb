class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action do
    if current_admin
      Rack::MiniProfiler.authorize_request
    end
  end

  protected

  def current_admin
    begin
      @current_admin ||= Admin.find(session[:admin_id]) if session[:admin_id]
    rescue Exception => e
      nil
    end
  end

end
