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

    near_companies = Company.near(39.000000, -76.000000).load

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
