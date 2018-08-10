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
#  role                   :string
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string
#  invited_by_id          :integer
#  invitations_count      :integer          default(0)
#  enabled                :boolean          default(TRUE)
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

require 'net/http'
require 'uri'

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
  has_many :friend_invites
  has_many :job_favourites
  has_many :favourite_jobs, through: :job_favourites, source: :job
  has_many :company_favourites
  has_many :favourite_companies, through: :company_favourites, source: :company

  attr_accessor :accept_terms_of_service, :accept_privacy_policy,
                :accept_code_of_conduct, :enforce_profile_edit, :user_type

  validates :email, presence: true, if: :enforce_profile_edit
  validates :first_name, :last_name, presence: true, on: :update, if: :step_job_info?
  validates :freelancer_profile, presence: true
  validates_associated :freelancer_profile

  validates_acceptance_of :accept_terms_of_service
  validates_acceptance_of :accept_privacy_policy
  validates_acceptance_of :accept_code_of_conduct

  before_validation :initialize_freelancer_profile
  after_create :check_for_invites
  after_save :add_credit_to_inviters, if: :confirmed_at_changed?

  accepts_nested_attributes_for :freelancer_profile
  accepts_nested_attributes_for :certifications, allow_destroy: true, reject_if: :reject_certification
  accepts_nested_attributes_for :freelancer_affiliations, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :freelancer_clearances, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :freelancer_portfolios, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :freelancer_insurances, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :friend_invites, reject_if: :all_blank, allow_destroy: true

  pg_search_scope :search, against: {
    first_name: "A",
    last_name: "A"
  }, associated_against: {
    freelancer_profile: [
      :job_types, :job_markets, :technical_skill_tags, :manufacturer_tags, :job_functions, :tagline, :bio
    ]
  }, using: {
    tsearch: { prefix: true, any_word: true }
  }

  pg_search_scope :name_or_email_search, against: {
    email: "A",
    first_name: "A",
    last_name: "A"
  }, using: {
    tsearch: { prefix: true }
  }

  delegate :registration_completed?, to: :freelancer_profile, allow_nil: true

  def connected?
    freelancer_profile.stripe_account_id.present?
  end

  def rating
    if freelancer_reviews.count > 0
      freelancer_reviews.average("(#{FreelancerReview::RATING_ATTRS.map(&:to_s).join('+')}) / #{FreelancerReview::RATING_ATTRS.length}").round
    else
      return nil
    end
  end

  def job_markets_for_job_type(job_type)
    all_job_markets = I18n.t("enumerize.#{job_type}_job_markets")
    return [] unless all_job_markets.kind_of?(Hash)
    freelancer_job_markets = []
    unless freelancer_profile.job_markets.nil?
      freelancer_profile.job_markets.each do |index, _|
        if all_job_markets[index.to_sym]
          freelancer_job_markets << all_job_markets[index.to_sym]
        end
      end
    end
    freelancer_job_markets
  end

  def job_functions_for_job_type(job_type)
    all_job_functions = I18n.t("enumerize.#{job_type}_job_functions")
    return [] unless all_job_functions.kind_of?(Hash)
    freelancer_job_functions = []
    unless freelancer_profile.job_functions.nil?
      freelancer_profile.job_functions.each do |index, _|
        if all_job_functions[index.to_sym]
          freelancer_job_functions << all_job_functions[index.to_sym]
        end
      end
    end
    freelancer_job_functions
  end

  def was_invited?
    FriendInvite.where(email: email, accepted: true).count > 0
  end

  def score
    score = 0
    score += 2 if self.freelancer_profile.avatar_data.present?
    score += 1 if self.freelancer_profile.address.present?
    score += 1 if self.freelancer_profile.area.present?
    score += 1 if self.freelancer_profile.city.present?
    score += 1 if self.freelancer_profile.state.present?
    score += 1 if self.freelancer_profile.postal_code.present?
    score += 1 if self.freelancer_profile.phone_number.present?
    score += 1 if self.freelancer_profile.bio.present?
    score += 1 if self.freelancer_profile.tagline.present?
    score += 1 if self.freelancer_profile.company_name.present?
    score += 1 if self.freelancer_profile.valid_driver
    score += 1 if self.freelancer_profile.available
    score += 5 * self.certifications.count
    score += 2 * self.freelancer_affiliations.count
    score += 2 * self.freelancer_clearances.count
    score += 1 * self.freelancer_insurances.count
    score += 1 * self.freelancer_portfolios.count
    score
  end

  def self.avg_rating(freelancer)
    if freelancer.freelancer_reviews.count == 0
      return nil
    end

    return freelancer.rating
  end

  def reject_certification(attrs)
    exists = attrs["id"].present?
    empty = attrs["certificate"].blank? and attrs["name"].blank?
    !exists and empty
  end

  def reject_freelancer_affiliation(attrs)
    exists = attrs["id"].present?
    empty = attrs["image"].blank? and attrs["name"].blank?
    !exists and empty
  end

  def reject_freelancer_clearance(attrs)
    exists = attrs["id"].present?
    empty = attrs["image"].blank? and attrs["description"].blank?
    !exists and empty
  end

  def reject_freelancer_portfolio(attrs)
    exists = attrs["id"].present?
    empty = attrs["image"].blank? and attrs["description"].blank?
    !exists and empty
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

  def check_for_invites
    return if FriendInvite.by_email(email).count.zero? || freelancer_profile.nil?
    self.freelancer_profile.avj_credit = 10
    save!
    FreelancerMailer.notice_credit_earned(self, 10).deliver_later
  end

  def add_credit_to_inviters
    return if FriendInvite.by_email(email).count.zero?
    FriendInvite.by_email(email).each do |invite|
      freelancer = invite.freelancer
      if freelancer.freelancer_profile.avj_credit.nil?
        credit_earned = 20
      elsif freelancer.freelancer_profile.avj_credit + 20 <= 200
        credit_earned = 20
      else
        credit_earned = 200 - freelancer.freelancer_profile.avj_credit
      end
      freelancer.freelancer_profile.avj_credit = freelancer.freelancer_profile.avj_credit.to_f + credit_earned
      freelancer.freelancer_profile.save!
      invite.update_attribute(:accepted, true)
      FreelancerMailer.notice_credit_earned(freelancer, credit_earned).deliver_later if credit_earned > 0
    end
  end

  def step_profile?
    freelancer_profile&.registration_step == "profile"
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
