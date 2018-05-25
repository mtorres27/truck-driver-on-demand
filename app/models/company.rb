# == Schema Information
#
# Table name: companies
#
#  id                        :integer          not null, primary key
#  token                     :string
#  name                      :string           not null
#  contact_name              :string           not null
#  address                   :string
#  formatted_address         :string
#  area                      :string
#  lat                       :decimal(9, 6)
#  lng                       :decimal(9, 6)
#  hq_country                :string
#  description               :string
#  avatar_data               :text
#  disabled                  :boolean          default(TRUE), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  messages_count            :integer          default(0), not null
#  company_reviews_count     :integer          default(0), not null
#  profile_header_data       :text
#  contract_preference       :string           default(NULL)
#  job_markets               :citext
#  technical_skill_tags      :citext
#  profile_views             :integer          default(0), not null
#  website                   :string
#  phone_number              :string
#  number_of_offices         :integer          default(0)
#  number_of_employees       :string
#  established_in            :integer
#  stripe_customer_id        :string
#  stripe_subscription_id    :string
#  stripe_plan_id            :string
#  subscription_cycle        :string
#  is_subscription_cancelled :boolean          default(FALSE)
#  subscription_status       :string
#  billing_period_ends_at    :datetime
#  last_4_digits             :string
#  card_brand                :string
#  exp_month                 :string
#  exp_year                  :string
#  header_color              :string           default("FF6C38")
#  country                   :string
#  header_source             :string           default("color")
#  province                  :string
#  sales_tax_number          :string
#  line2                     :string
#  city                      :string
#  state                     :string
#  postal_code               :string
#  job_types                 :citext
#  manufacturer_tags         :citext
#  plan_id                   :integer
#  is_trial_applicable       :boolean          default(TRUE)
#  waived_jobs               :integer          default(1)
#

class Company < ApplicationRecord
  extend Enumerize
  include PgSearch
  include Geocodable
  include Disableable
  include AvatarUploader[:avatar]
  include ProfileHeaderUploader[:profile_header]

  belongs_to :plan, foreign_key: 'plan_id', optional: true

  has_one :user, as: :meta, dependent: :destroy
  accepts_nested_attributes_for :user
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

  serialize :job_types
  serialize :job_markets
  serialize :technical_skill_tags
  serialize :manufacturer_tags

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

  scope :new_registrants, -> { where(disabled: true) }

  after_create :add_to_hubspot

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

  def city_state_country
    str = ""
    str += "#{city}, " if city.present?
    str += "#{state}, " if state.present?
    str += "#{country.upcase}" if country.present?
    str
  end

  audited

  attr_accessor :enforce_profile_edit

    validates_presence_of :name,
      :email,
      :address,
      :city,
      :postal_code,
      :area,
      :country,
      :description,
      :established_in,
      if: :enforce_profile_edit


  # def province=(value)
  #   write_attribute(:state, value)
  #   super(value)
  # end

  pg_search_scope :search, against: {
    name: "A",
    email: "A",
    contact_name: "B",
    area: "B",
    job_types: "B",
    job_markets: "B",
    technical_skill_tags: "B",
    manufacturer_tags: "B",
    formatted_address: "C",
    description: "C"
  }, using: {
      tsearch: { prefix: true }
  }

  pg_search_scope :name_or_email_search, against: {
      name: "A",
      email: "A",
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

  def email
    user.email
  end

  def self.avg_rating(company)
    if company.company_reviews_count == 0
      return nil
    end

    return company.rating
  end

  after_save :check_if_should_do_geocode
  def check_if_should_do_geocode
    if saved_changes.include?("address") or saved_changes.include?("city") or (!address.nil? and lat.nil?) or (!city.nil? and lat.nil?)
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

  def job_markets_for_job_type(job_type)
    all_job_markets = I18n.t("enumerize.#{job_type}_job_markets")
    return [] unless all_job_markets.kind_of?(Hash)
    freelancer_job_markets = []
    job_markets.each do |index, value|
      if all_job_markets[index.to_sym]
        freelancer_job_markets << all_job_markets[index.to_sym]
      end
    end
    freelancer_job_markets
  end

  def canada_country?
    country == 'ca'
  end

  def self.do_all_geocodes
    Company.all.each do |f|
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
      company: name,
      firstname: contact_name.split(" ")[0],
      lastname: contact_name.split(" ")[1],
      lifecyclestage: "customer",
      im_an: "AV Company",
    )
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
