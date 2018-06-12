# == Schema Information
#
# Table name: company_datas
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
#  company_reviews_count     :integer          default(0), not null
#  profile_header_data       :text
#  contract_preference       :string           default("no_preference")
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
#  company_id                :integer
#

class CompanyData < ApplicationRecord
  self.table_name = "company_datas"

  extend Enumerize
  include Geocodable
  include AvatarUploader[:avatar]
  include ProfileHeaderUploader[:profile_header]
  include Disableable

  belongs_to :company

  scope :new_registrants, -> { where(disabled: true) }

  after_save :check_if_should_do_geocode

  enumerize :contract_preference, in: [:prefer_fixed, :prefer_hourly, :prefer_daily]
  enumerize :number_of_employees, in: [
      :one_to_ten,
      :eleven_to_one_hundred,
      :one_hundred_one_to_one_thousand,
      :more_than_one_thousand
  ]
  enumerize :country, in: [
      :at, :au, :be, :ca, :ch, :de, :dk, :es, :fi, :fr, :gb, :hk, :ie, :it, :jp, :lu, :nl, :no, :nz, :pt, :se, :sg, :us
  ]
  enumerize :header_source, in: [
      :color,
      :wallpaper
  ]

  serialize :job_types
  serialize :job_markets
  serialize :technical_skill_tags
  serialize :manufacturer_tags

  def check_if_should_do_geocode
    if saved_changes.include?("address") or saved_changes.include?("city") or (!address.nil? and lat.nil?) or (!city.nil? and lat.nil?)
      do_geocode
      update_columns(lat: lat, lng: lng)
    end
  end
end
