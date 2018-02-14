# == Schema Information
#
# Table name: companies
#
#  id                        :integer          not null, primary key
#  token                     :string
#  email                     :citext           not null
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
#  keywords                  :citext
#  skills                    :citext
#  profile_views             :integer          default(0), not null
#  website                   :string
#  phone_number              :string
#  number_of_offices         :integer          default(0)
#  number_of_employees       :string
#  established_in            :integer
#  encrypted_password        :string           default(""), not null
#  reset_password_token      :string
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :inet
#  last_sign_in_ip           :inet
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
#  confirmation_token        :string
#  confirmed_at              :datetime
#  confirmation_sent_at      :datetime
#  header_source             :string           default("color")
#  province                  :string
#  sales_tax_number          :string
#  line2                     :string
#  city                      :string
#  state                     :string
#  postal_code               :string
#

require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "sign up with google" do
    auth_hash = Faker::Omniauth.unique.google.deep_symbolize_keys
    company = Company.find_or_create_from_auth_hash(auth_hash)

    assert_equal auth_hash.dig(:info, :email)&.downcase, company.email
    assert_equal auth_hash.dig(:info, :name), company.name
  end

  test "sign in with google" do
    auth_hash = Faker::Omniauth.unique.google.deep_symbolize_keys

    existing = create(:company, email: auth_hash.dig(:info, :email)&.downcase)
    signed_in = Company.find_or_create_from_auth_hash(auth_hash)

    assert_equal existing.email, signed_in.email
  end

  test "sign up with facebook" do
    auth_hash = Faker::Omniauth.unique.facebook.deep_symbolize_keys
    company = Company.find_or_create_from_auth_hash(auth_hash)

    assert_equal auth_hash.dig(:info, :email)&.downcase, company.email
    assert_equal auth_hash.dig(:info, :name), company.name
  end

  test "sign in with facebook" do
    auth_hash = Faker::Omniauth.unique.facebook.deep_symbolize_keys

    existing = create(:company, email: auth_hash.dig(:info, :email)&.downcase)
    signed_in = Company.find_or_create_from_auth_hash(auth_hash)

    assert_equal existing.email, signed_in.email
  end

  test "sign up with linkedin" do
    auth_hash = Faker::Omniauth.unique.linkedin.deep_symbolize_keys
    company = Company.find_or_create_from_auth_hash(auth_hash)

    assert_equal auth_hash.dig(:info, :email)&.downcase, company.email
    assert_equal auth_hash.dig(:info, :name), company.name
  end

  test "sign in with linkedin" do
    auth_hash = Faker::Omniauth.unique.linkedin.deep_symbolize_keys

    existing = create(:company, email: auth_hash.dig(:info, :email)&.downcase)
    signed_in = Company.find_or_create_from_auth_hash(auth_hash)

    assert_equal existing.email, signed_in.email
  end

  # https://github.com/pairshaped/postgis-on-rails-example
  test "near companies" do
    far_company = create(
      :company,
      lat: 40.000000,
      lng: -77.000000
    )

    near_company = create(
      :company,
      lat: 39.010000,
      lng: -75.990000
    )

    near_companies = Company.nearby(39.000000, -76.000000).load

    assert_equal 1, near_companies.size
    assert_equal near_company, near_companies.first
  end

  test "queue geocode" do
    company = create(
      :company,
      address: "301 Front St W, Toronto, ON M5V 2T6, Canada"
    )
    assert_enqueued_jobs 1 do
      company.queue_geocode
    end
  end

  # Test includes the actual remote API call (Google Maps)
  test "do geocode" do
    company = create(
      :company,
      address: "301 Front St W, Toronto, ON M5V 2T6, Canada"
    )

    company.do_geocode
    assert_equal 43.642505, company.lat.to_f
    assert_equal -79.387362, company.lng.to_f
  end

end
