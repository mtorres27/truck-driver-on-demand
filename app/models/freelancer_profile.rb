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
#  tagline                  :string
#  bio                      :text
#  job_markets              :citext
#  years_of_experience      :integer          default(0), not null
#  profile_views            :integer          default(0), not null
#  available                :boolean          default(TRUE), not null
#  disabled                 :boolean          default(TRUE), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  freelancer_reviews_count :integer          default(0), not null
#  technical_skill_tags     :citext
#  verified                 :boolean          default(FALSE)
#  country                  :string
#  freelancer_team_size     :string
#  freelancer_type          :string
#  line2                    :string
#  state                    :string
#  postal_code              :string
#  service_areas            :string
#  city                     :string
#  profile_score            :integer
#  valid_driver             :boolean
#  own_tools                :boolean
#  company_name             :string
#  job_functions            :citext
#  manufacturer_tags        :citext
#  registration_step        :string
#  province                 :string
#  freelancer_id            :integer
#  requested_verification   :boolean          default(FALSE)
#  pay_unit_time_preference :string
#  pay_rate                 :float
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
  include Disableable
  include EasyPostgis
  include PgSearch

  belongs_to :freelancer, required: false

  scope :new_registrants, -> { where(disabled: true, registration_step: "wicked_finish") }
  scope :incomplete_registrations, -> { where.not(registration_step: "wicked_finish") }

  after_save :check_if_should_do_geocode
  after_save :add_to_hubspot
  after_save :send_welcome_email, if: :registration_step_changed?
  before_save :set_profile_score
  before_create :set_default_step

  delegate :enforce_profile_edit, to: :freelancer, allow_nil: true
  delegate :full_name, to: :freelancer

  accepts_nested_attributes_for :freelancer

  validates :years_of_experience, numericality: { only_integer: true }
  validates :pay_rate, numericality: { greater_than: 0 }, allow_nil: true
  validates :country, :city, presence: true, on: :update, if: :step_job_info?
  validates :address, :city, :country, presence: true, if: :enforce_profile_edit

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
    :wallpaper,
    :default
  ]

  enumerize :country, in: [
    :at, :au, :be, :ca, :ch, :de, :dk, :es, :fi, :fr, :gb, :hk, :ie, :it, :jp, :lu, :nl, :no, :nz, :pt, :se, :sg, :us
  ]

  pg_search_scope :search, against: {
      job_markets: "A",
      technical_skill_tags: "A",
      manufacturer_tags: "A",
      job_functions: "A",
      tagline: "A",
      bio: "A"
  }, using: {
      tsearch: { prefix: true, any_word: true }
  }

  pg_search_scope :name_or_email_search, against: {},
                  associated_against: { freelancer: [:email, :first_name, :last_name]
                  }, using: { tsearch: { prefix: true }}

  def check_if_should_do_geocode
    if saved_changes.include?("address") or saved_changes.include?("city") or (!address.nil? and lat.nil?) or (!city.nil? and lat.nil?)
      do_geocode
      update_columns(lat: lat, lng: lng)
    end
  end

  def registration_completed?
    registration_step == "wicked_finish"
  end

  def step_job_info?
    registration_step == "job_info"
  end

  def user
    freelancer
  end

  def city_state_province
    "#{city}#{ ", #{state}" unless state.blank?}"
  end

  def type_and_company
    str = ""
    if freelancer_type.present?
      str += freelancer_type.humanize
      str += ", #{company_name}" if company_name.present?
    else
      company_name
    end
  end

  def job_types
    has_system_integration = has_system_integration_job_markets || has_system_integration_job_functions
    has_live_events_staging_and_rental = has_live_events_staging_and_rental_job_markets || has_live_events_staging_and_rental_job_functions

    return "System Integration & Live Events Staging And Rental" if has_live_events_staging_and_rental && has_system_integration

    if has_system_integration
      "System Integration"
    elsif has_live_events_staging_and_rental
      "Live Events Staging And Rental"
    else
      "None"
    end
  end

  def has_system_integration_job_markets
    I18n.t("enumerize.system_integration_job_markets").each do |key, _|
      return true if job_markets.present? && job_markets[key] == '1'
    end
    false
  end

  def has_live_events_staging_and_rental_job_markets
    I18n.t("enumerize.live_events_staging_and_rental_job_markets").each do |key, _|
      return true if job_markets.present? && job_markets[key] == '1'
    end
    false
  end

  def has_system_integration_job_functions
    I18n.t("enumerize.system_integration_job_functions").each do |key, _|
      return true if job_functions.present? && job_functions[key] == '1'
    end
    false
  end

  def has_live_events_staging_and_rental_job_functions
    I18n.t("enumerize.live_events_staging_and_rental_job_functions").each do |key, _|
      return true if job_functions.present? && job_functions[key] == '1'
    end
    false
  end

  private

  def set_profile_score
    self.profile_score = freelancer&.score
  end

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
      im_an: "AV Professional",
      country: country,
      city: city,
      state: state,
      company: company_name,
      av_junction_id: freelancer&.id,
      job_types: job_types,
      phone: freelancer&.phone_number
    )
  end
end
