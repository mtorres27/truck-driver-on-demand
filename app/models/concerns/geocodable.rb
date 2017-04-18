module Geocodable
  extend ActiveSupport::Concern
   include ERB::Util

  ADDRESS_ATTRS = %w(street1 city state country zip).freeze

  def address
    ADDRESS_ATTRS.map { |attr| self.send(attr) }.compact.join(", ")
  end

  def address_changed?
    ADDRESS_ATTRS.any? { |attr| self.send("saved_change_to_#{attr}?") }
  end

  def queue_geocode
    if address.empty?
      # We have no address, but if we used to have one, then make sure we empty
      # out the existing coords.
      if latitude && longitude
        self.latitude = nil
        self.longitude = nil
        save
      end

    # We have values, check if any of them changed
    elsif address_changed?
      # Queue the background job to update the latitude and langitude
      GeocoderJob.perform_later self
    end
  end

  def do_geocode
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{url_encode(address)}&key=#{Rails.application.secrets.google_maps_api_key}"
    # Make the API request
    result = Net::HTTP.get(URI.parse(url))
    puts result
  end

  # Called by the background worker
  def do_geocode!
    do_geocode
    save
  end

  included do
    after_save :queue_geocode
  end
end
