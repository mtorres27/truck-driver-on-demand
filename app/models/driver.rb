# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  first_name             :string
#  last_name              :string
#  type                   :string
#  messages_count         :integer          default(0), not null
#  company_id             :bigint
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string
#  invited_by_id          :bigint
#  invitations_count      :integer          default(0)
#  phone_number           :string
#  role                   :string
#  enabled                :boolean          default(TRUE)
#  login_code             :string
#  city                   :string
#

require "net/http"
require "uri"

# rubocop:disable Metrics/ClassLength
class Driver < User

  include PgSearch

  audited

  has_one :driver_profile, dependent: :destroy
  has_many :applicants, -> { order(updated_at: :desc) }, dependent: :destroy
  has_many :jobs, through: :applicants
  has_many :messages, -> { order(created_at: :desc) }, as: :authorable, dependent: :destroy
  has_many :company_reviews, dependent: :destroy
  has_many :driver_reviews, dependent: :nullify
  has_many :certifications, -> { order(updated_at: :desc) }, dependent: :destroy
  has_many :driver_affiliations
  has_many :driver_clearances
  has_many :driver_portfolios
  has_many :driver_insurances
  has_many :job_favourites
  has_many :favourite_jobs, through: :job_favourites, source: :job
  has_many :company_favourites
  has_many :favourite_companies, through: :company_favourites, source: :company

  attr_accessor :accept_terms_of_service, :accept_privacy_policy,
                :accept_code_of_conduct, :enforce_profile_edit, :user_type

  validates :email, presence: true, if: :enforce_profile_edit
  validates :phone_number, length: { minimum: 7 }, allow_blank: true
  validates :driver_profile, presence: true
  validates_associated :driver_profile

  validates_acceptance_of :accept_terms_of_service
  validates_acceptance_of :accept_privacy_policy
  validates_acceptance_of :accept_code_of_conduct

  before_validation :initialize_driver

  accepts_nested_attributes_for :driver_profile
  accepts_nested_attributes_for :certifications, allow_destroy: true, reject_if: :reject_certification
  accepts_nested_attributes_for :driver_affiliations, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :driver_clearances, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :driver_portfolios, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :driver_insurances, reject_if: :all_blank, allow_destroy: true

  pg_search_scope :search, against: {
    first_name: "A",
    last_name: "A",
  }, associated_against: {
    driver_profile: %i[
      job_markets technical_skill_tags manufacturer_tags job_functions tagline bio
    ],
  }, using: {
    tsearch: { prefix: true, any_word: true },
  }

  pg_search_scope :name_or_email_search, against: {
    email: "A",
    first_name: "A",
    last_name: "A",
  }, using: {
    tsearch: { prefix: true },
  }

  pg_search_scope :admin_search, against: {
    email: "A",
    first_name: "A",
    last_name: "A",
    phone_number: "A",
  }, associated_against: {
    driver_profile: %i[
      address
      area
      country
      driver_type
      state
      service_areas
      city
      company_name
      job_markets
      technical_skill_tags
      manufacturer_tags
      job_functions
      tagline
      bio
    ],
  }, using: {
    tsearch: { prefix: true },
  }

  def messages_for_company(company)
    Message.messages_for(company, self)
  end

  def companies_for_messaging
    all_messages = messages.to_a + Message.where(receivable_type: "User", receivable_id: id).to_a
    # rubocop:disable Metrics/LineLength
    all_messages.sort_by(&:created_at).reverse.map { |msg| msg.authorable.is_a?(Company) ? msg.authorable : msg.receivable }.uniq
    # rubocop:enable Metrics/LineLength
  end

  def new_messages_from_company?(company)
    notifications.where(authorable: company, read_at: nil).count.positive?
  end

  def connections_count
    companies_for_messaging.count
  end

  def rating
    return unless driver_reviews.count.positive

    # rubocop:disable Metrics/LineLength
    driver_reviews.average("(#{DriverReview::RATING_ATTRS.map(&:to_s).join('+')}) / #{DriverReview::RATING_ATTRS.length}").round
    # rubocop:enable Metrics/LineLength
  end

  def job_markets_for_job_type(job_type)
    all_job_markets = I18n.t("enumerize.#{job_type}_job_markets")
    return [] unless all_job_markets.is_a?(Hash)

    driver_job_markets = []

    driver_profile.job_markets&.each do |index, _|
      driver_job_markets << all_job_markets[index.to_sym] if all_job_markets[index.to_sym]
    end
    driver_job_markets
  end

  def job_functions_for_job_type(job_type)
    all_job_functions = I18n.t("enumerize.#{job_type}_job_functions")
    return [] unless all_job_functions.is_a?(Hash)

    driver_job_functions = []
    driver_profile.job_functions&.each do |index, _|
      driver_job_functions << all_job_functions[index.to_sym] if all_job_functions[index.to_sym]
    end
    driver_job_functions
  end

  # rubocop:disable Metrics/AbcSize
  def score
    # score = 0
    # score += 2 if driver_profile.avatar_data.present?
    # score += 1 if driver_profile.address.present?
    # score += 1 if driver_profile.area.present?
    # score += 1 if driver_profile.city.present?
    # score += 1 if driver_profile.state.present?
    # score += 1 if driver_profile.postal_code.present?
    # score += 1 if phone_number.present?
    # score += 1 if driver_profile.bio.present?
    # score += 1 if driver_profile.tagline.present?
    # score += 1 if driver_profile.company_name.present?
    # score += 1 if driver_profile.valid_driver
    # score += 1 if driver_profile.available
    # score += 5 if certifications.count.positive?
    # score += 2 if driver_affiliations.count.positive?
    # score += 2 if driver_clearances.count.positive?
    # score += 1 if driver_insurances.count.positive?
    # score += 1 if driver_portfolios.count.positive?
    # (score.to_f / 24) * 100
    0
  end
  # rubocop:enable Metrics/AbcSize

  def self.avg_rating(driver)
    return nil if driver.driver_reviews.count.zero?

    driver.rating
  end

  def reject_certification(attrs)
    exists = attrs["id"].present?
    empty = attrs["name"].blank?
    !exists && empty
  end

  def reject_driver_affiliation(attrs)
    exists = attrs["id"].present?
    (empty = attrs["image"].blank?) && attrs["name"].blank?
    !exists && empty
  end

  def reject_driver_clearance(attrs)
    exists = attrs["id"].present?
    (empty = attrs["image"].blank?) && attrs["description"].blank?
    !exists && empty
  end

  def reject_driver_portfolio(attrs)
    exists = attrs["id"].present?
    (empty = attrs["image"].blank?) && attrs["description"].blank?
    !exists && empty
  end

  def self.do_all_geocodes
    Driver.all.each do |f|
      data = f.driver_profile
      p "Doing geocode for " + f.id.to_s + "(#{data.compile_address})"
      data.do_geocode
      data.update_columns(formatted_address: f.formatted_address, lat: f.lat, lng: f.lng)
      sleep 1
    end
  end

  def send_confirmation_instructions
    super
    send_confirmation_sms
  end

  def send_login_code
    if generate_login_code
      client = Twilio::REST::Client.new ENV['twilio_account_sid'], ENV['twilio_auth_token']
      client.messages.create(
        from: ENV['twilio_number'],
        to: phone_number,
        body: "Here's your confirmation code #{login_code}"
      )
      true
    else
      false
    end
  end

  def generate_login_code
    self.update(login_code: rand(000000..999900).to_s.rjust(6, "0"))
  end

  private

  def send_confirmation_sms
    confirmation_url = "#{ENV['host_url']}users/confirmation?confirmation_token=#{confirmation_token}"
    client = Twilio::REST::Client.new ENV['twilio_account_sid'], ENV['twilio_auth_token']
    client.messages.create(
      from: ENV['twilio_number'],
      to: phone_number,
      body: "#{confirmation_url} Hello from Truckker! Thanks for signing up with us. Navigate to the link above to start using the platform."
    )
  end

  def initialize_driver
    self.driver_profile ||= build_driver_profile
    self.confirm unless self.confirmed_at.present?
  end

  def step_job_info?
    driver_profile&.registration_step == "job_info"
  end

  protected

  def registration_step_changed?
    driver_profile&.registration_step_changed?
  end

end
# rubocop:enable Metrics/ClassLength
