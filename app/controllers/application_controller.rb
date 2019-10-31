# frozen_string_literal: true

class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  require "erb"
  include ERB::Util
  include Pundit

  helper_method :current_company

  before_action do
    if Rails.env.development?
      # Rack::MiniProfiler.authorize_request
    end
  end

  unless Rails.application.config.consider_all_requests_local
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from ActionView::MissingTemplate, with: :render_404
    # rescue_from StandardError do |e|
    #   render_500
    # end
  end

  rescue_from Pundit::NotAuthorizedError, with: :render_401
  rescue_from ActionController::InvalidAuthenticityToken, with: :invalid_credentials

  def invalid_credentials
    flash[:error] = "Invalid Email or password"
    redirect_to new_user_session_path
  end

  def after_inactive_sign_up_path_for(_resource)
    cookies.delete(:onboarding)
    confirm_email_path
  end

  def current_company
    @current_company ||= current_user&.try(:company)
  end

  def do_geocode(address)
    # rubocop:disable Metrics/LineLength
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{url_encode(address)}&key=#{ENV['google_maps_js_api_key']}"
    # rubocop:enable Metrics/LineLength
    # Make the API request
    begin
      res = JSON.parse(Net::HTTP.get(URI.parse(url)), symbolize_names: true)
      if res[:status] == "OK"
        formatted_address = res[:results][0][:formatted_address]
        lat = res[:results][0][:geometry][:location][:lat]
        lng = res[:results][0][:geometry][:location][:lng]

        return { address: formatted_address, lat: lat, lng: lng }
      end
    rescue StandardError => e
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

  def render_500
    respond_to do |format|
      format.html { render template: "errors/internal_server_error", status: 500 }
    end
  end

  # rubocop:disable Naming/AccessorMethodName
  def get_matches
    # rubocop:enable Naming/AccessorMethodName
    @distance = params[:search][:distance] if params[:search].present?
    @freelancers = @job.matches(@distance)
  end

  protected

  def after_sign_in_path_for(resource)
    return admin_root_path if resource.admin?
    return freelancer_root_path if resource.freelancer?

    if resource.company_user?
      if resource.enabled?
        return edit_company_company_user_path(resource) if resource.sign_in_count == 1 && resource.role != "Owner"

        return company_root_path
      end
      flash.discard
      flash[:error] = "Your account was disabled by your manager."
      sign_out resource
    end
    root_path
  end

end
