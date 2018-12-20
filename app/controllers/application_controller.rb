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
    rescue_from StandardError do |e|
      Rollbar.error(e)
      render_500
    end
  end

  rescue_from Pundit::NotAuthorizedError, with: :render_401

  def after_inactive_sign_up_path_for(resource)
    cookies.delete(:onboarding)
    confirm_email_path
  end

  def current_company
    @current_company ||= current_user&.try(:company)
  end

  def do_geocode(address)
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{url_encode(address)}&key=#{Rails.application.secrets.google_maps_js_api_key}"
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

  def render_500
    respond_to do |format|
      format.html { render template: "errors/internal_server_error", status: 500 }
    end
  end

  def get_matches
    @distance = params[:search][:distance] if params[:search].present?
    @freelancer_profiles = FreelancerProfile.where(disabled: false).where("job_types like ?", "%#{@job.job_type}%")
    @address_for_geocode = @job.address
    @address_for_geocode += ", #{CS.states(@job.country.to_sym)[@job.state_province.to_sym]}" if @job.state_province.present?
    @address_for_geocode += ", #{CS.countries[@job.country.upcase.to_sym]}" if @job.country.present?

    # check for cached version of address
    if Rails.cache.read(@address_for_geocode)
      @geocode = Rails.cache.read(@address_for_geocode)
    else
      # save cached version of address
      @geocode = do_geocode(@address_for_geocode)
      Rails.cache.write(@address_for_geocode, @geocode)
    end

    if @geocode
      point = OpenStruct.new(:lat => @geocode[:lat], :lng => @geocode[:lng])
      if @distance.nil?
        @distance = 160934
      end
      @freelancer_profiles = @freelancer_profiles.nearby(@geocode[:lat], @geocode[:lng], @distance).with_distance(point).order("distance")
      @freelancers = Freelancer.where(id: @freelancer_profiles.map(&:freelancer_id))
    else
      flash[:error] = "Unable to search geocode. Please try again."
      @freelancers = Freelancer.none
    end
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
