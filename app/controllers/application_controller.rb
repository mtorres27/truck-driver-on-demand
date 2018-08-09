class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  require "erb"
  include ERB::Util
  include Pundit

  before_action do
    if Rails.env.development?
      # Rack::MiniProfiler.authorize_request
    end
  end

  unless Rails.application.config.consider_all_requests_local
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from ActionView::MissingTemplate, with: :render_404
  end

  rescue_from Pundit::NotAuthorizedError, with: :render_401

  def after_inactive_sign_up_path_for(resource)
    cookies.delete(:onboarding)
    confirm_email_path
  end

  def do_geocode(address)
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{url_encode(address)}&key=#{Rails.application.secrets.google_maps_api_key}"
    # Make the API request
    begin
      res = JSON.parse(Net::HTTP.get(URI.parse(url)), symbolize_names: true)
      if res[:status] == "OK"
        formatted_address = res[:results][0][:formatted_address]
        lat = res[:results][0][:geometry][:location][:lat]
        lng = res[:results][0][:geometry][:location][:lng]

        return { address: formatted_address, lat: lat, lng: lng }
      end
    rescue Exception => e
      puts e
      logger.error e
      return false
    end
  end

  def render_404
    respond_to do |format|
      format.html { render template: "errors/not_found", status: :not_found }
    end
  end

  def render_401
    respond_to do |format|
      format.html { render template: "errors/unauthorized", status: :unauthorized }
    end
  end

  protected

  def after_sign_in_path_for(resource)
    return admin_root_path if resource.admin?
    return freelancer_root_path if resource.freelancer?
    return company_root_path if resource.company_user?
    root_path
  end

end
