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
#

require "net/http"
require "uri"

class DriverProfile < ApplicationRecord

  extend Enumerize
  include AvatarUploader[:avatar]
  include Disableable
  include PgSearch

  belongs_to :driver, required: false

  scope :new_registrants, -> { where(disabled: true, registration_step: "wicked_finish") }
  scope :incomplete_registrations, -> { where.not(registration_step: "wicked_finish") }

  after_save :send_welcome_email, if: :registration_step_changed?
  before_save :set_profile_score
  before_create :set_default_step

  delegate :enforce_profile_edit, to: :driver, allow_nil: true
  delegate :full_name, to: :driver

  accepts_nested_attributes_for :driver

  validates :city, :province, presence: true, on: :update, if: :step_expertise?
  validates :address, :city, :province, presence: true, if: :enforce_profile_edit

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

  def registration_completed?
    registration_step == "wicked_finish"
  end

  def step_expertise?
    registration_step == "expertise"
  end

  def user
    driver
  end

  def city_province
    "#{city}#{", #{province}" unless province.blank?}"
  end

  private

  def set_profile_score
    self.profile_score = driver&.score
  end

  def set_default_step
    self.registration_step ||= "personal"
  end

  def send_welcome_email
    return if driver&.confirmed? || !registration_completed? || driver&.confirmation_sent_at.present?
    
    driver&.send_confirmation_instructions
  end

end