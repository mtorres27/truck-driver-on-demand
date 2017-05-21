class ApplicationController < ActionController::Base
  include Authentication

  protect_from_forgery with: :exception

  before_action do
    if current_admin
      Rack::MiniProfiler.authorize_request
    end
  end
end
