# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
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
#  company_id             :integer
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string
#  invited_by_id          :integer
#  invitations_count      :integer          default(0)
#  enabled                :boolean          default(TRUE)
#  role                   :string
#  phone_number           :string
#
# Indexes
#
#  index_users_on_company_id                         (company_id)
#  index_users_on_confirmation_token                 (confirmation_token) UNIQUE
#  index_users_on_email                              (email) UNIQUE
#  index_users_on_invitation_token                   (invitation_token) UNIQUE
#  index_users_on_invitations_count                  (invitations_count)
#  index_users_on_invited_by_id                      (invited_by_id)
#  index_users_on_invited_by_type_and_invited_by_id  (invited_by_type,invited_by_id)
#  index_users_on_reset_password_token               (reset_password_token) UNIQUE
#

require "net/http"
require "uri"

# rubocop:disable Metrics/ClassLength
class Freelancer < User

  include PgSearch

  audited

  has_one :freelancer_profile, dependent: :destroy
  has_many :applicants, -> { order(updated_at: :desc) }, dependent: :destroy
  has_many :jobs, through: :applicants
  has_many :messages, -> { order(created_at: :desc) }, as: :authorable, dependent: :destroy
  has_many :company_reviews, dependent: :destroy
  has_many :freelancer_reviews, dependent: :nullify
  has_many :certifications, -> { order(updated_at: :desc) }, dependent: :destroy
  has_many :freelancer_affiliations
  has_many :freelancer_clearances
  has_many :freelancer_portfolios
  has_many :freelancer_insurances
  has_many :job_favourites
  has_many :favourite_jobs, through: :job_favourites, source: :job
  has_many :company_favourites
  has_many :favourite_companies, through: :company_favourites, source: :company

  attr_accessor :accept_terms_of_service, :accept_privacy_policy,
                :accept_code_of_conduct, :enforce_profile_edit, :user_type

  validates :email, presence: true, if: :enforce_profile_edit
  validates :phone_number, length: { minimum: 7 }, allow_blank: true
  validates :freelancer_profile, presence: true
  validates_associated :freelancer_profile

  validates_acceptance_of :accept_terms_of_service
  validates_acceptance_of :accept_privacy_policy
  validates_acceptance_of :accept_code_of_conduct

  before_validation :initialize_freelancer_profile

  accepts_nested_attributes_for :freelancer_profile
  accepts_nested_attributes_for :certifications, allow_destroy: true, reject_if: :reject_certification
  accepts_nested_attributes_for :freelancer_affiliations, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :freelancer_clearances, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :freelancer_portfolios, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :freelancer_insurances, reject_if: :all_blank, allow_destroy: true

  pg_search_scope :search, against: {
    first_name: "A",
    last_name: "A",
  }, associated_against: {
    freelancer_profile: %i[
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
    freelancer_profile: %i[
      address
      area
      country
      freelancer_type
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

  delegate :registration_completed?, to: :freelancer_profile, allow_nil: true

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
    return unless freelancer_reviews.count.positive

    # rubocop:disable Metrics/LineLength
    freelancer_reviews.average("(#{FreelancerReview::RATING_ATTRS.map(&:to_s).join('+')}) / #{FreelancerReview::RATING_ATTRS.length}").round
    # rubocop:enable Metrics/LineLength
  end

  def job_markets_for_job_type(job_type)
    all_job_markets = I18n.t("enumerize.#{job_type}_job_markets")
    return [] unless all_job_markets.is_a?(Hash)

    freelancer_job_markets = []

    freelancer_profile.job_markets&.each do |index, _|
      freelancer_job_markets << all_job_markets[index.to_sym] if all_job_markets[index.to_sym]
    end
    freelancer_job_markets
  end

  def job_functions_for_job_type(job_type)
    all_job_functions = I18n.t("enumerize.#{job_type}_job_functions")
    return [] unless all_job_functions.is_a?(Hash)

    freelancer_job_functions = []
    freelancer_profile.job_functions&.each do |index, _|
      freelancer_job_functions << all_job_functions[index.to_sym] if all_job_functions[index.to_sym]
    end
    freelancer_job_functions
  end

  # rubocop:disable Metrics/AbcSize
  def score
    score = 0
    score += 2 if freelancer_profile.avatar_data.present?
    score += 1 if freelancer_profile.address.present?
    score += 1 if freelancer_profile.area.present?
    score += 1 if freelancer_profile.city.present?
    score += 1 if freelancer_profile.state.present?
    score += 1 if freelancer_profile.postal_code.present?
    score += 1 if phone_number.present?
    score += 1 if freelancer_profile.bio.present?
    score += 1 if freelancer_profile.tagline.present?
    score += 1 if freelancer_profile.company_name.present?
    score += 1 if freelancer_profile.valid_driver
    score += 1 if freelancer_profile.available
    score += 5 if certifications.count.positive?
    score += 2 if freelancer_affiliations.count.positive?
    score += 2 if freelancer_clearances.count.positive?
    score += 1 if freelancer_insurances.count.positive?
    score += 1 if freelancer_portfolios.count.positive?
    (score.to_f / 24) * 100
  end
  # rubocop:enable Metrics/AbcSize

  def self.avg_rating(freelancer)
    return nil if freelancer.freelancer_reviews.count.zero?

    freelancer.rating
  end

  def reject_certification(attrs)
    exists = attrs["id"].present?
    empty = attrs["name"].blank?
    !exists && empty
  end

  def reject_freelancer_affiliation(attrs)
    exists = attrs["id"].present?
    (empty = attrs["image"].blank?) && attrs["name"].blank?
    !exists && empty
  end

  def reject_freelancer_clearance(attrs)
    exists = attrs["id"].present?
    (empty = attrs["image"].blank?) && attrs["description"].blank?
    !exists && empty
  end

  def reject_freelancer_portfolio(attrs)
    exists = attrs["id"].present?
    (empty = attrs["image"].blank?) && attrs["description"].blank?
    !exists && empty
  end

  def self.do_all_geocodes
    Freelancer.all.each do |f|
      data = f.freelancer_profile
      p "Doing geocode for " + f.id.to_s + "(#{data.compile_address})"
      data.do_geocode
      data.update_columns(formatted_address: f.formatted_address, lat: f.lat, lng: f.lng)
      sleep 1
    end
  end

  private

  def initialize_freelancer_profile
    self.freelancer_profile ||= build_freelancer_profile
  end

  def step_job_info?
    freelancer_profile&.registration_step == "job_info"
  end

  protected

  def confirmation_required?
    registration_completed?
  end

  def registration_step_changed?
    freelancer_profile&.registration_step_changed?
  end

end
# rubocop:enable Metrics/ClassLength
