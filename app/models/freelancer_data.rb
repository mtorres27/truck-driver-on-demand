require 'net/http'
require 'uri'

class FreelancerData < ApplicationRecord
  self.table_name = "freelancer_datas"

  include Geocodable
  include AvatarUploader[:avatar]
  include ProfileHeaderUploader[:profile_header]

  belongs_to :freelancer

  after_save :check_if_should_do_geocode
  def check_if_should_do_geocode
    if saved_changes.include?("address") or saved_changes.include?("city") or (!address.nil? and lat.nil?) or (!city.nil? and lat.nil?)
      do_geocode
      update_columns(lat: lat, lng: lng)
    end
  end
end