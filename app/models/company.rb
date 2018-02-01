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

  attr_accessor :accept_terms_of_service
  attr_accessor :accept_privacy_policy
  attr_accessor :accept_code_of_conduct

  validates_acceptance_of :accept_terms_of_service
  validates_acceptance_of :accept_privacy_policy
  validates_acceptance_of :accept_code_of_conduct

  validates_presence_of :country, :on => :create
  validates_presence_of :city, :on => :create

  validates :phone_number, length: { minimum: 7 }, allow_blank: true

  # enumerize :currency, in: [
  #   :cad,
  #   :euro,
  #   :ruble,
  #   :rupee,
  #   :usd,
  #   :yen,
  # ]

  enumerize :contract_preference, in: [:prefer_fixed, :prefer_hourly, :prefer_daily]

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

  enumerize :province, in: [
    :AB, :BC, :MB, :NB, :NL, :NT, :NS, :NU, :ON, :PE, :QC, :SK, :YT
  ]

  enumerize :header_source, in: [
    :color,
    :wallpaper
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

  def renew_month
    self.expires_at = Date.today + 1.month
  end

  def renew_year
    self.expires_at = Date.today + 1.year
  end

  audited

  attr_accessor :enforce_profile_edit

    validates_presence_of :name,
      :email,
      :address,
      :line2,
      :city,
      :postal_code,
      :area,
      :country,
      :description,
      :established_in,
      :keywords,
      :skills,
      if: :enforce_profile_edit

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
          property: 'company',
          value: name
        },
        {
          property: "firstname",
          value: contact_name.split(" ")[0]
        },
        {
          property: "lastname",
          value: contact_name.split(" ")[1]
        },
        {
          property: "lifecyclestage",
          value: "customer"
        },
        {
          property: "im_an",
          value: "AV Company"
        },
      ]
    }

    req.body = data.to_json
    res = http.start { |http| http.request req }
  end

  before_create :start_trial

  def start_trial
    self.subscription_status = "trialing"
    self.billing_period_ends_at = (Time.now + 3.months).to_datetime
  end

  # def province=(value)
  #   write_attribute(:state, value)
  #   super(value)
  # end

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

    def self.do_all_geocodes
      Company.all.each do |f|
        p "Doing geocode for " + f.id.to_s + "(#{f.compile_address})"
        f.do_geocode
        f.save

        sleep 1
      end
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
