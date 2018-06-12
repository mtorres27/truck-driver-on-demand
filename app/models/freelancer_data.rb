# == Schema Information
#
# Table name: freelancer_datas
#
#  id                       :integer          not null, primary key
#  token                    :string
#  name                     :string
#  avatar_data              :text
#  address                  :string
#  formatted_address        :string
#  area                     :string
#  lat                      :decimal(9, 6)
#  lng                      :decimal(9, 6)
#  pay_unit_time_preference :string
#  pay_per_unit_time        :string
#  tagline                  :string
#  bio                      :text
#  job_markets              :citext
#  years_of_experience      :integer          default(0), not null
#  profile_views            :integer          default(0), not null
#  projects_completed       :integer          default(0), not null
#  available                :boolean          default(TRUE), not null
#  disabled                 :boolean          default(TRUE), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  freelancer_reviews_count :integer          default(0), not null
#  technical_skill_tags     :citext
#  profile_header_data      :text
#  verified                 :boolean          default(FALSE)
#  header_color             :string           default("FF6C38")
#  country                  :string
#  freelancer_team_size     :string
#  freelancer_type          :string
#  header_source            :string           default("color")
#  stripe_account_id        :string
#  stripe_account_status    :text
#  currency                 :string
#  sales_tax_number         :string
#  line2                    :string
#  state                    :string
#  postal_code              :string
#  service_areas            :string
#  city                     :string
#  phone_number             :string
#  profile_score            :integer
#  valid_driver             :boolean
#  own_tools                :boolean
#  company_name             :string
#  special_avj_fees         :decimal(10, 2)
#  job_types                :citext
#  job_functions            :citext
#  manufacturer_tags        :citext
#  avj_credit               :decimal(10, 2)
#  registration_step        :string
#  freelancer_id            :integer
#

require 'net/http'
require 'uri'

class FreelancerData < ApplicationRecord
  self.table_name = "freelancer_datas"

  extend Enumerize
  include Geocodable
  include AvatarUploader[:avatar]
  include ProfileHeaderUploader[:profile_header]
  include Disableable

  belongs_to :freelancer

  scope :new_registrants, -> { where(disabled: true) }

  after_save :check_if_should_do_geocode

  serialize :job_types
  serialize :job_markets
  serialize :technical_skill_tags
  serialize :job_functions
  serialize :manufacturer_tags

  enumerize :pay_unit_time_preference, in: [
      :fixed, :hourly, :daily
  ]

  enumerize :freelancer_type, in: [
      :independent, :service_provider
  ]

  enumerize :freelancer_team_size, in: [
      :less_than_five,
      :six_to_ten,
      :eleven_to_twenty,
      :twentyone_to_thirty,
      :more_than_thirty
  ]

  enumerize :header_source, in: [
      :color,
      :wallpaper
  ]

  enumerize :country, in: [
      :at, :au, :be, :ca, :ch, :de, :dk, :es, :fi, :fr, :gb, :hk, :ie, :it, :jp, :lu, :nl, :no, :nz, :pt, :se, :sg, :us
  ]

  def check_if_should_do_geocode
    if saved_changes.include?("address") or saved_changes.include?("city") or (!address.nil? and lat.nil?) or (!city.nil? and lat.nil?)
      do_geocode
      update_columns(lat: lat, lng: lng)
    end
  end
end
