# == Schema Information
#
# Table name: freelancers
#
#  id                       :integer          not null, primary key
#  token                    :string
#  email                    :citext           not null
#  name                     :string           not null
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
#  messages_count           :integer          default(0), not null
#  freelancer_reviews_count :integer          default(0), not null
#  technical_skill_tags     :citext
#  profile_header_data      :text
#  verified                 :boolean          default(FALSE)
#  encrypted_password       :string           default(""), not null
#  reset_password_token     :string
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer          default(0), not null
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :inet
#  last_sign_in_ip          :inet
#  header_color             :string           default("FF6C38")
#  country                  :string
#  confirmation_token       :string
#  confirmed_at             :datetime
#  confirmation_sent_at     :datetime
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
#  job_types                :citext
#  job_functions            :citext
#  manufacturer_tags        :citext
#  special_avj_fees         :decimal(10, 2)
#  avj_credit               :decimal(10, 2)
#

require 'net/http'
require 'uri'

class Freelancer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  extend Enumerize
  include PgSearch
  include Geocodable
  include Disableable
  include AvatarUploader[:avatar]
  include ProfileHeaderUploader[:profile_header]
  include EasyPostgis

  has_many :applicants, -> { order(updated_at: :desc) }, dependent: :destroy
  has_many :jobs, through: :applicants
  has_many :messages, -> { order(created_at: :desc) }, as: :authorable, dependent: :destroy
  has_many :company_reviews, dependent: :destroy
  has_many :freelancer_reviews, dependent: :nullify
  has_many :certifications, -> { order(updated_at: :desc) }, dependent: :destroy
  accepts_nested_attributes_for :certifications, allow_destroy: true, reject_if: :reject_certification

  has_many :freelancer_affiliations
  accepts_nested_attributes_for :freelancer_affiliations, :reject_if => :all_blank, :allow_destroy => true

  has_many :freelancer_clearances
  accepts_nested_attributes_for :freelancer_clearances, :reject_if => :all_blank, :allow_destroy => true

  has_many :freelancer_portfolios
  accepts_nested_attributes_for :freelancer_portfolios, :reject_if => :all_blank, :allow_destroy => true

  has_many :freelancer_insurances
  accepts_nested_attributes_for :freelancer_insurances, :reject_if => :all_blank, :allow_destroy => true

  has_many :friend_invites
  accepts_nested_attributes_for :friend_invites, :reject_if => :all_blank, :allow_destroy => true

  has_many :job_favourites
  has_many :favourite_jobs, through: :job_favourites, source: :job

  has_many :company_favourites
  has_many :favourite_companies, through: :company_favourites, source: :company

  serialize :job_types
  serialize :job_markets
  serialize :technical_skill_tags
  serialize :job_functions
  serialize :manufacturer_tags

  validates :years_of_experience, numericality: { only_integer: true }

  validates_presence_of :country, :on => :create
  validates_presence_of :city, :on => :create

  validates :phone_number, length: { minimum: 7 }, allow_blank: true

  validates :phone_number, length: { minimum: 7 }, on: :update, allow_blank: true

  audited

  def connected?; !stripe_account_id.nil?; end

  attr_accessor :accept_terms_of_service
  attr_accessor :accept_privacy_policy
  attr_accessor :accept_code_of_conduct

  validates_acceptance_of :accept_terms_of_service
  validates_acceptance_of :accept_privacy_policy
  validates_acceptance_of :accept_code_of_conduct

  attr_accessor :enforce_profile_edit

    validates_presence_of :name,
      :email,
      :address,
      :city,
      :state,
      :postal_code,
      :country,
      :freelancer_type,
      :service_areas,
      :bio,
      :years_of_experience,
      :pay_unit_time_preference,
      if: :enforce_profile_edit

  scope :new_registrants, -> { where(disabled: true) }

  after_create :add_to_hubspot
  after_create :check_for_invites
  after_create :send_welcome_email

  pg_search_scope :search, against: {
    name: "A",
    job_types: "B",
    job_markets: "B",
    technical_skill_tags: "B",
    manufacturer_tags: "B",
    job_functions: "B",
    tagline: "C",
    bio: "C"
  }, using: {
    tsearch: { prefix: true, any_word: true }
  }

  pg_search_scope :name_or_email_search, against: {
      name: "A",
      email: "A",
  }, using: {
      tsearch: { prefix: true }
  }

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

  attr_accessor :user_type

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
    unless job_markets.nil?
      job_markets.each do |index, value|
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
    unless job_functions.nil?
      job_functions.each do |index, value|
        if all_job_functions[index.to_sym]
          freelancer_job_functions << all_job_functions[index.to_sym]
        end
      end
    end
    freelancer_job_functions
  end

  def score
    score = 0
    score += 1 if self.name.present?
    score += 5 if self.avatar_data.present?
    score += 1 if self.email.present?
    score += 1 if self.address.present?
    score += 1 if self.area.present?
    score += 1 if self.city.present?
    score += 1 if self.state.present?
    score += 1 if self.postal_code.present?
    score += 1 if self.phone_number.present?

    score += 1 if self.bio.present?
    score += 1 if self.tag_line.present?
    score += 1 if self.company_name.present?
    score += 1 if self.valid_driver

    score += 1 if self.available

    score += 5 * self.certifications.count
    score += 2 * self.freelancer_affiliations.count
    score += 2 * self.freelancer_clearances.count
    score += 1 * self.freelancer_insurances.count
    score += 1 * self.freelancer_portfolios.count
    score
  end

  def self.avg_rating(freelancer)
    if freelancer.freelancer_reviews_count == 0
      return nil
    end

    return freelancer.rating
  end

  after_save :check_if_should_do_geocode
  def check_if_should_do_geocode
    if saved_changes.include?("address") or saved_changes.include?("city") or (!address.nil? and lat.nil?) or (!city.nil? and lat.nil?)
      do_geocode
      update_columns(lat: lat, lng: lng)
    end
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
      p "Doing geocode for " + f.id.to_s + "(#{f.compile_address})"
      f.do_geocode
      f.update_columns(lat: f.lat, lng: f.lng)

      sleep 1
    end
  end

  private

  def add_to_hubspot
    return unless Rails.application.secrets.enabled_hubspot

    Hubspot::Contact.createOrUpdate(email,
      firstname: name.split(" ")[0],
      lastname: name.split(" ")[1],
      lifecyclestage: "customer",
      im_am: "AV Freelancer",
    )
  end

  def send_welcome_email
    FreelancerMailer.verify_your_identity(self).deliver_later
  end

  def check_for_invites
    return if FriendInvite.by_email(email).count.zero?

    self.avj_credit = 20
    save!
    FreelancerMailer.notice_credit_earned(self, 20).deliver_later
    FriendInvite.by_email(email).each do |invite|
      freelancer = invite.freelancer
      if freelancer.avj_credit.nil?
        freelancer.avj_credit = 50
      elsif freelancer.avj_credit + 50 <= 400
        freelancer.avj_credit += 50
      else
        freelancer.avj_credit = 400
      end
      freelancer.save!
      invite.update_attribute(:accepted, true)
      FreelancerMailer.notice_credit_earned(freelancer, 50).deliver_later
    end
  end

end
