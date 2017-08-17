class ApplicationController < ActionController::Base
  include Authentication
  require "erb"
  include ERB::Util

  protect_from_forgery with: :exception

  before_action do
    if Rails.env.development?
      Rack::MiniProfiler.authorize_request
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

end
