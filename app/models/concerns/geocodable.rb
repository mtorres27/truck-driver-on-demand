module Geocodable
  extend ActiveSupport::Concern
  include ERB::Util

  def queue_geocode
    if address.blank?
      # We have no address, but if we used to have one, then make sure we empty
      # out the existing coords.
      if lat && lng
        self.lat = nil
        self.lng = nil
        save
      end

    # We have values, check if any of them changed
    elsif saved_change_to_address?
      # Queue the background job to update the latitude and langitude
      GeocoderJob.perform_later self
    end
  end

  def do_geocode
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{url_encode(address)}&key=#{Rails.application.secrets.google_maps_api_key}"
    # Make the API request
    begin
      res = JSON.parse(Net::HTTP.get(URI.parse(url)), symbolize_names: true)
      if res[:status] == "OK"
        # puts "Formatted address: #{res[:results][0][:formatted_address]}"
        # puts "Point: #{res[:results][0][:geometry][:location]}"
        self.formatted_address = res[:results][0][:formatted_address]
        self.lat = res[:results][0][:geometry][:location][:lat]
        self.lng = res[:results][0][:geometry][:location][:lng]
        # puts "Stored: #{lat}, #{lng}"
        return true
      end
    rescue Exception => e
      puts e
      logger.error e
      return false
    end
  end

  # Using a callback makes testing a pita and adds implicitness to our code,
  # making it harder to debug down the road. Figure out a better way to make sure
  # geocoding happens.
  # included do
  #   after_save :queue_geocode
  # end
end