# frozen_string_literal: true

# == Schema Information
#
# Table name: driver_profiles
#
#  id                     :bigint           not null, primary key
#  token                  :string
#  avatar_data            :text
#  tagline                :string
#  bio                    :text
#  years_of_experience    :integer          default(0), not null
#  profile_views          :integer          default(0), not null
#  available              :boolean          default(TRUE), not null
#  disabled               :boolean          default(TRUE), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  driver_reviews_count   :integer          default(0), not null
#  verified               :boolean          default(FALSE)
#  driver_type            :string
#  postal_code            :string
#  service_areas          :string
#  city                   :string
#  profile_score          :integer
#  registration_step      :string
#  driver_id              :integer
#  requested_verification :boolean          default(FALSE)
#  license_class          :string
#  province               :string
#  transmission_and_speed :citext
#  freight_type           :citext
#  other_skills           :citext
#  vehicle_type           :citext
#  truck_type             :citext
#  trailer_type           :citext
#  address_line1          :string
#  address_line2          :string
#  background_check_data  :text
#  completed_profile      :boolean          default(FALSE)
#

require "net/http"
require "uri"

class DriverProfile < ApplicationRecord

  extend Enumerize
  include AvatarUploader[:avatar]
  include BackgroundCheckUploader[:background_check]
  include Disableable
  include PgSearch

  belongs_to :driver, required: false

  scope :new_registrants, -> { where(disabled: true, registration_step: "wicked_finish") }
  scope :incomplete_registrations, -> { where.not(registration_step: "wicked_finish") }

  after_create :send_welcome_email
  before_save :set_profile_score
  before_create :set_default_step

  delegate :enforce_profile_edit, to: :driver, allow_nil: true
  delegate :complete_profile_form, to: :driver, allow_nil: true
  delegate :full_name, to: :driver

  accepts_nested_attributes_for :driver

  validates :avatar_data, :address_line1, :city, :postal_code, presence: true, if: :complete_profile_form

  serialize :additional_skills
  serialize :trailer_type
  serialize :truck_type
  serialize :transmission_and_speed
  serialize :freight_type
  serialize :vehicle_type
  serialize :other_skills

  enumerize :driver_type, in: I18n.t("enumerize.driver_type").keys
  enumerize :license_class, in: I18n.t("enumerize.license_class").keys
  enumerize :province, in: I18n.t("enumerize.province").keys

  def user
    driver
  end

  def city_province
    "#{user.city}#{", #{province}" unless province.blank?}"
  end

  def registration_completed?
    registration_step == "wicked_finish"
  end

  private

  def set_profile_score
    self.profile_score = driver&.score
  end

  def set_default_step
    self.registration_step ||= "confirm_phone"
  end

  def send_welcome_email
    return if driver&.confirmed? || driver&.confirmation_sent_at.present?
    
    driver&.send_confirmation_instructions
  end

end
