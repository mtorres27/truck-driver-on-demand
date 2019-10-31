# frozen_string_literal: true

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

  def compile_address
    address = ""
    address += self.address + " " if self.address

    address += line2 + " " if self.class.name != "Job" && line2

    address += city + " " if self.class.name != "Job" && city

    address += state + " " if self.class.name != "Job" && state

    address += I18n.t("enumerize.country." + country) if country

    address
  end

  # rubocop:disable Metrics/AbcSize
  def do_geocode
    # rubocop:disable Metrics/LineLength
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{url_encode(compile_address)}&key=#{ENV['google_maps_js_api_key']}"
    # rubocop:enable Metrics/LineLength
    # Make the API request
    begin
      res = JSON.parse(Net::HTTP.get(URI.parse(url)), symbolize_names: true)
      if res[:status] == "OK"
        puts "Formatted address: #{res[:results][0][:formatted_address]}" unless Rails.env.test?
        puts "Point: #{res[:results][0][:geometry][:location]}" unless Rails.env.test?
        self.formatted_address = res[:results][0][:formatted_address]
        self.lat = res[:results][0][:geometry][:location][:lat]
        self.lng = res[:results][0][:geometry][:location][:lng]
        puts "Stored: #{lat}, #{lng}" unless Rails.env.test?
        return true
      end
    rescue StandardError => e
      puts e
      logger.error e
      return false
    end
  end
  # rubocop:enable Metrics/AbcSize

  included do
    # This SQL needs to stay exactly in sync with it's related index (index_on_???_loc)
    # otherwise the index won't be used. (don't even add whitespace!)
    # https://github.com/pairshaped/postgis-on-rails-example
    scope :nearby, lambda { |lat, lng, distance_in_meters = 2000|
      where(
        <<-SQL.squish,
          ST_DWithin(
            ST_GeographyFromText(
              'SRID=4326;POINT(' || #{table_name}.lng || ' ' || #{table_name}.lat || ')'
            ),
            ST_GeographyFromText('SRID=4326;POINT(#{lng} #{lat})'),
            #{distance_in_meters}
          )
        SQL
      )
    }

    # Using a callback makes testing a pita and adds implicitness to our code,
    # making it harder to debug down the road. Figure out a better way to make sure
    # geocoding happens.
    # after_save :queue_geocode
  end

end
