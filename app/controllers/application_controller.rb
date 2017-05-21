class ApplicationController < ActionController::Base
  include Authentication

  protect_from_forgery with: :exception

  before_action do
    if Rails.env.development?
      Rack::MiniProfiler.authorize_request
    end
  end
end
