# == Schema Information
#
# Table name: freelancer_profiles
#
#  id                       :integer          not null, primary key
#  token                    :string
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
# Indexes
#
#  index_freelancer_profiles_on_area                  (area)
#  index_freelancer_profiles_on_available             (available)
#  index_freelancer_profiles_on_disabled              (disabled)
#  index_freelancer_profiles_on_freelancer_id         (freelancer_id)
#  index_freelancer_profiles_on_job_functions         (job_functions)
#  index_freelancer_profiles_on_job_markets           (job_markets)
#  index_freelancer_profiles_on_manufacturer_tags     (manufacturer_tags)
#  index_freelancer_profiles_on_technical_skill_tags  (technical_skill_tags)
#  index_on_freelancer_profiles_loc                   (st_geographyfromtext((((('SRID=4326;POINT('::text || lng) || ' '::text) || lat) || ')'::text)))
#  index_on_freelancers_loc                           (st_geographyfromtext((((('SRID=4326;POINT('::text || lng) || ' '::text) || lat) || ')'::text)))
#

require 'net/http'
require 'uri'

class FreelancerProfile < ApplicationRecord

  extend Enumerize
  include Geocodable
  include AvatarUploader[:avatar]
  include ProfileHeaderUploader[:profile_header]
  include Disableable
  include EasyPostgis

  belongs_to :freelancer, required: false

  scope :new_registrants, -> { where(disabled: true) }

  after_save :check_if_should_do_geocode
  after_save :add_to_hubspot
  after_save :send_welcome_email, if: :registration_step_changed?
  before_create :set_default_step

  accepts_nested_attributes_for :freelancer

  validates :years_of_experience, numericality: { only_integer: true }
  validates :phone_number, length: { minimum: 7 }, allow_blank: true
  validates :phone_number, length: { minimum: 7 }, on: :update, allow_blank: true
  validates :job_types, presence: true, on: :update, if: :step_profile?
  validates :avatar, :tagline, :bio, presence: true, on: :update, if: :registration_completed?
  validates :country, :city, presence: true, on: :update, if: :step_job_info?

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

  def registration_completed?
    registration_step == "wicked_finish"
  end

  def step_profile?
    registration_step == "profile"
  end

  def step_job_info?
    registration_step == "job_info"
  end

  def profile_form_filled?
    avatar.present? && bio.present? && tagline.present?
  end

  private

  def set_default_step
    self.registration_step ||= "personal"
  end

  def send_welcome_email
    return if freelancer&.confirmed? || !registration_completed? || freelancer&.confirmation_sent_at.present?
    freelancer&.send_confirmation_instructions
  end

  def add_to_hubspot
    return unless Rails.application.secrets.enabled_hubspot
    return if !registration_completed? || changes[:registration_step].nil?

    Hubspot::Contact.createOrUpdate(
      freelancer&.email,
      firstname: freelancer&.first_name,
      lastname: freelancer&.last_name,
      lifecyclestage: "customer",
      im_an: "AV Freelancer",
    )
  end
end
