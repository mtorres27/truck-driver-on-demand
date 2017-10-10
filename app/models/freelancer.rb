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

  has_many :job_favourites
  has_many :favourite_jobs, through: :job_favourites, source: :job

  has_many :company_favourites
  has_many :favourite_companies, through: :company_favourites, source: :company

  serialize :keywords
  serialize :skills

  validates :years_of_experience, numericality: { only_integer: true }

  audited

  attr_accessor :accept_terms_of_service
  attr_accessor :accept_privacy_policy
  attr_accessor :accept_code_of_conduct

  validates_acceptance_of :accept_terms_of_service
  validates_acceptance_of :accept_privacy_policy
  validates_acceptance_of :accept_code_of_conduct

  after_create :add_to_hubspot

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

  pg_search_scope :search, against: {
    name: "A",
    keywords: "B",
    skills: "B",
    tagline: "C",
    bio: "C"
  }, using: {
    tsearch: { prefix: true, any_word: true }
  }

  enumerize :pay_unit_time_preference, in: [
    :fixed, :hourly
  ]

  enumerize :freelancer_type, in: [
    :independent, :team
  ]

  enumerize :freelancer_team_size, in: [
    :less_than_five, 
    :six_to_ten, 
    :eleven_to_twenty, 
    :twentyone_to_thirty, 
    :more_than_thirty
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

  def self.avg_rating(freelancer)
    if freelancer.freelancer_reviews_count == 0
      return nil
    end

    return freelancer.rating
  end

  after_save :check_if_should_do_geocode
  def check_if_should_do_geocode
    if saved_changes.include?("address") or (!address.nil? and lat.nil?)
      do_geocode
      update_columns(lat: lat, lng: lng)
    end
  end

  def reject_certification(attrs)
    exists = attrs["id"].present?
    empty = attrs["certificate"].blank? and attrs["name"].blank?
    !exists and empty
  end
end
