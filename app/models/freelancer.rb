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
#  pay_per_unit_time        :integer
#  tagline                  :string
#  bio                      :text
#  keywords                 :citext
#  years_of_experience      :integer          default(0), not null
#  profile_views            :integer          default(0), not null
#  projects_completed       :integer          default(0), not null
#  available                :boolean          default(TRUE), not null
#  disabled                 :boolean          default(FALSE), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
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
      :country,
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
    score += 3 if self.email.present?
    score += 3 if self.phone_number.present?
    score += 3 if self.bio.present?
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
    api_key = "5c7ad391-2bfe-4d11-9ba3-82b5622212ba"
    url = "https://api.hubapi.com/contacts/v1/contact/createOrUpdate/email/#{email}/?hapikey=#{api_key}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'
    req = Net::HTTP::Post.new uri
    data = {
        properties: [
            {
                property: "email",
                value: email
            },
            {
                property: "firstname",
                value: name.split(" ")[0]
            },
            {
                property: "lastname",
                value: name.split(" ")[1]
            },
            {
                property: "lifecyclestage",
                value: "customer"
            },
            {
                property: "im_an",
                value: "AV Freelancer"
            },
        ]
    }
    req.body = data.to_json
    res = http.start { |http| http.request req }
  end

  def send_welcome_email
    FreelancerMailer.verify_your_identity(self).deliver
  end

  def check_for_invites
    if FriendInvite.where(email: email)
      self.avj_credit = 20
      save!
      FreelancerMailer.notice_credit_earned(self, 20).deliver
      FriendInvite.where(email: email).each do |invite|
        freelancer = invite.freelancer
        freelancer.avj_credit = freelancer.avj_credit.nil? ? 50 : freelancer.avj_credit + 50
        freelancer.save!
        invite.update_attribute(:accepted, true)
        FreelancerMailer.notice_credit_earned(freelancer, 50).deliver
      end
    end
  end
end
