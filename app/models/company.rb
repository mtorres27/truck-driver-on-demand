# == Schema Information
#
# Table name: companies
#
#  id                        :integer          not null, primary key
#  token                     :string
#  name                      :string
#  contact_name              :string
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
#  registration_step         :string
#  email                     :citext           not null
#  encrypted_password        :string           default(""), not null
#  reset_password_token      :string
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer          not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :inet
#  last_sign_in_ip           :inet
#  confirmation_token        :string
#  confirmed_at              :datetime
#  confirmation_sent_at      :datetime
#

class Company < User
  extend Enumerize
  include PgSearch
  include Disableable

  belongs_to :plan, foreign_key: 'plan_id', optional: true

  has_one :company_data, dependent: :destroy
  has_many :projects, -> { order(updated_at: :desc) }, dependent: :destroy
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

  attr_accessor :accept_terms_of_service, :accept_privacy_policy, :accept_code_of_conduct,
                :first_name, :last_name, :enforce_profile_edit, :user_type

  validates_acceptance_of :accept_terms_of_service
  validates_acceptance_of :accept_privacy_policy
  validates_acceptance_of :accept_code_of_conduct

  validates :phone_number, length: { minimum: 7 }, allow_blank: true
  validates :first_name, :last_name, :name, :country, :city, presence: true, on: :update,  if: :step_job_info?
  validates :job_types, presence: true, on: :update, if: :step_profile?
  validates :avatar, :description, :established_in, :number_of_employees, :number_of_offices, :website, :area, presence: true, on: :update, if: :confirmed_company?

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

  enumerize :header_source, in: [
    :color,
    :wallpaper
  ]

  accepts_nested_attributes_for :featured_projects, allow_destroy: true, reject_if: :reject_featured_projects
  accepts_nested_attributes_for :company_installs, allow_destroy: true, reject_if: :reject_company_installs

  scope :new_registrants, -> { where(disabled: true) }

  before_save :set_name, if: :step_job_info?
  after_save :add_to_hubspot
  before_create :set_default_step
  after_save :send_confirmation_email, if: :confirmed_company?

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

  def registration_completed?
    company_data.registration_step == "wicked_finish" if company_data
  end

  def profile_form_filled?
    avatar.present? && description.present? && established_in.present? && area.present? &&
    number_of_employees.present? && number_of_offices.present? && website.present?
  end

  private

  def add_to_hubspot
    return unless Rails.application.secrets.enabled_hubspot
    return if !registration_completed? || changes[:registration_step].nil?

    Hubspot::Contact.createOrUpdate(email,
      company: name,
      firstname: contact_name.split(" ")[0],
      lastname: contact_name.split(" ")[1],
      lifecyclestage: "customer",
      im_an: "AV Company",
    )
  end

  def step_profile?
    company_data.registration_step == "profile" if company_data
  end

  def step_job_info?
    company_data.registration_step == "job_info" if company_data
  end

  def set_default_step
    company_data.registration_step ||= "personal" if company_data
  end

  def set_name
    self.contact_name ||= "#{first_name} #{last_name}"
  end

  def send_confirmation_email
    return if confirmed? || !registration_completed? || confirmation_sent_at.present?
    self.send_confirmation_instructions
  end

  def confirmed_company?
    registration_completed? && self.confirmed? == false
  end

  protected

  def confirmation_required?
    registration_completed?
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
