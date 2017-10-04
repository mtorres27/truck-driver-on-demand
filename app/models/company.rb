# == Schema Information
#
# Table name: companies
#
#  id                :integer          not null, primary key
#  token             :string
#  email             :citext           not null
#  name              :string           not null
#  contact_name      :string           not null
#  currency          :string           default("CAD"), not null
#  address           :string
#  formatted_address :string
#  area              :string
#  lat               :decimal(9, 6)
#  lng               :decimal(9, 6)
#  hq_country        :string
#  description       :string
#  avatar_data       :text
#  disabled          :boolean          default(FALSE), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Company < ApplicationRecord
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

  has_many :projects, -> { order(updated_at: :desc) }, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :applicants, dependent: :destroy
  has_many :quotes, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :messages, -> { order(created_at: :desc) }, as: :authorable
  has_many :freelancer_reviews, dependent: :nullify
  has_many :company_reviews, dependent: :destroy
  has_many :featured_projects, dependent: :destroy
  has_many :favourites
  has_many :favourite_freelancers, through: :favourites, source: :freelancer
  has_many :company_installs, dependent: :destroy

  enumerize :currency, in: [
    :cad,
    :euro,
    :ruble,
    :rupee,
    :usd,
    :yen,
  ]
  
  enumerize :contract_preference, in: [:prefer_fixed, :prefer_hourly]
  enumerize :number_of_employees, in: [
    :one_to_ten,
    :eleven_to_one_hundred,
    :one_hundred_one_to_one_thousand,
    :more_than_one_thousand
  ]

  serialize :keywords
  serialize :skills

  enumerize :country, in: [
    :at, :au, :be, :ca, :ch, :de, :dk, :es, :fi, :fr, :gb, :hk, :ie, :it, :jp, :lu, :nl, :no, :nz, :pt, :se, :sg, :us
  ]

  accepts_nested_attributes_for :featured_projects, allow_destroy: true, reject_if: :reject_featured_projects
  accepts_nested_attributes_for :company_installs, allow_destroy: true, reject_if: :reject_company_installs
  
  def freelancers
    Freelancer.
    joins(applicants: :job).
    where(jobs: { company_id: id }).
    where(applicants: { state: :accepted }).
    order(:name)
  end
  
  audited

  after_create :add_to_hubspot
  
    def add_to_hubspot
      Hubspot::Contact.create_or_update!([
        {email: email, firstname: name, lastname: ""}
      ])
    end
  
  pg_search_scope :search, against: {
    name: "A",
    email: "A",
    contact_name: "B",
    area: "B",
    formatted_address: "C",
    description: "C"
    }, using: {
      tsearch: { prefix: true }
    }
    
    attr_accessor :user_type
    # We want to populate both name and contact_name on sign up
    before_validation :set_contact_name, on: :create
    def set_contact_name
      self.contact_name = name unless contact_name
    end
    
    def rating
      if company_reviews.count > 0
        company_reviews.average("(#{CompanyReview::RATING_ATTRS.map(&:to_s).join('+')}) / #{CompanyReview::RATING_ATTRS.length}").round
      else
        return nil
      end
    end
    
    def self.avg_rating(company)
      if company.company_reviews_count == 0
        return nil
      end
  
      return company.rating
    end

    after_save :check_if_should_do_geocode
    def check_if_should_do_geocode
      if saved_changes.include?("address") or (!address.nil? and lat.nil?)
        do_geocode
        update_columns(lat: lat, lng: lng)
      end
    end

    def reject_featured_projects(attrs)
      exists = attrs["id"].present?
      empty = attrs["file"].blank? and attrs["name"].blank?
      !exists and empty
    end

    def reject_company_installs(attrs)
      exists = attrs["id"].present?
      empty = attrs["year"].blank? and attrs["installs"].blank
      !exists and empty
    end

  # This SQL needs to stay exactly in sync with it's related index (index_on_companies_location)
  # otherwise the index won't be used. (don't even add whitespace!)
  # https://github.com/pairshaped/postgis-on-rails-example
  # scope :near, -> (lat, lng, distance_in_meters = 2000) {
  #   where(%{
  #     ST_DWithin(
  #       ST_GeographyFromText(
  #         'SRID=4326;POINT(' || companies.lng || ' ' || companies.lat || ')'
  #       ),
  #       ST_GeographyFromText('SRID=4326;POINT(%f %f)'),
  #       %d
  #     )
  #   } % [lng, lat, distance_in_meters])
  # }
end
