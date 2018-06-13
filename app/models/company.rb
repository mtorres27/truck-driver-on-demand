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
#  type                   :string
#  messages_count         :integer          default(0), not null
#

class Company < User
  include PgSearch

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
  has_one :company_data, dependent: :destroy
  accepts_nested_attributes_for :company_data

  attr_accessor :accept_terms_of_service, :accept_privacy_policy, :accept_code_of_conduct,
                :first_name, :last_name, :enforce_profile_edit, :user_type

  validates_acceptance_of :accept_terms_of_service
  validates_acceptance_of :accept_privacy_policy
  validates_acceptance_of :accept_code_of_conduct

  validates :phone_number, length: { minimum: 7 }, allow_blank: true
  validates :first_name, :last_name, :name, :country, :city, presence: true, on: :update,  if: :step_job_info?
  validates :job_types, presence: true, on: :update, if: :step_profile?
  validates :avatar, :description, :established_in, :number_of_employees, :number_of_offices, :website, :area, presence: true, on: :update, if: :confirmed_company?

  accepts_nested_attributes_for :featured_projects, allow_destroy: true, reject_if: :reject_featured_projects
  accepts_nested_attributes_for :company_installs, allow_destroy: true, reject_if: :reject_company_installs

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
    email: "A"
  }, associated_against: {
      company_data: [:name, :contact_name, :area, :job_types, :job_markets, :technical_skill_tags,
                     :manufacturer_tags, :formatted_address, :description]
  }, using: {
      tsearch: { prefix: true }
  }

  pg_search_scope :name_or_email_search, against: {
      email: "A"
  }, associated_against: {
      company_data: [:name]
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
    if company.company_reviews.count == 0
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
    company_job_markets = []
    company_data.job_markets.each do |index, _value|
      if all_job_markets[index.to_sym]
        company_job_markets << all_job_markets[index.to_sym]
      end
    end
    company_job_markets
  end

  def canada_country?
    company_data.country == 'ca'
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

  def name_initials
    company_data.name.blank? ? email[0].upcase : company_data.name.split.map(&:first).map(&:upcase).join
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
