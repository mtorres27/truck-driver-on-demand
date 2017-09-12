class ApplicationController < ActionController::Base
  require "erb"
  include ERB::Util
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception

  before_action do
    if Rails.env.development?
      # Rack::MiniProfiler.authorize_request
    end
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

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:email, :password, :password_confirmation, :name, :contact_name)
    end
  end

end
