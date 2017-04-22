# == Schema Information
#
# Table name: freelancers
#
#  id                       :integer          not null, primary key
#  email                    :string           not null
#  name                     :string
#  address                  :string
#  formatted_address        :string
#  area                     :string
#  lat                      :decimal(9, 6)
#  lng                      :decimal(9, 6)
#  pay_unit_time_preference :string
#  pay_per_unit_time        :integer
#  tagline                  :string
#  bio                      :text
#  markets                  :string
#  skills                   :string
#  years_of_experience      :integer          default("0"), not null
#  profile_views            :integer          default("0"), not null
#  projects_completed       :integer          default("0"), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

require "test_helper"

class FreelancerTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  # https://github.com/pairshaped/postgis-on-rails-example
  test "near freelancers" do
    far_freelancer = create(
      :freelancer,
      lat: 40.000000,
      lng: -77.000000
    )

    near_freelancer = create(
      :freelancer,
      lat: 39.010000,
      lng: -75.990000
    )

    near_freelancers = Freelancer.near(39.000000, -76.000000).load

    assert_equal 1, near_freelancers.size
    assert_equal near_freelancer, near_freelancers.first
  end

  test "queue geocode" do
    freelancer = create(
      :freelancer,
      address: "301 Front St W, Toronto, ON M5V 2T6, Canada"
    )
    assert_enqueued_jobs 1 do
      freelancer.queue_geocode
    end
  end

  # Test includes the actual remote API call (Google Maps)
  test "do geocode" do
    freelancer = create(
      :freelancer,
      address: "301 Front St W, Toronto, ON M5V 2T6, Canada"
    )

    freelancer.do_geocode
    assert_equal 43.642505, freelancer.lat.to_f
    assert_equal -79.387362, freelancer.lng.to_f
  end

  test "sign up with google" do
    auth_hash = Faker::Omniauth.unique.google.deep_symbolize_keys
    freelancer = Freelancer.find_or_create_from_auth_hash(auth_hash)

    assert_equal auth_hash.dig(:info, :email)&.downcase, freelancer.email
    assert_equal auth_hash.dig(:info, :name), freelancer.name
  end

  test "sign in with google" do
    auth_hash = Faker::Omniauth.unique.google.deep_symbolize_keys

    existing = create(:freelancer, email: auth_hash.dig(:info, :email)&.downcase)
    signed_in = Freelancer.find_or_create_from_auth_hash(auth_hash)

    assert_equal existing.email, signed_in.email
  end

  test "sign up with facebook" do
    auth_hash = Faker::Omniauth.unique.facebook.deep_symbolize_keys
    freelancer = Freelancer.find_or_create_from_auth_hash(auth_hash)

    assert_equal auth_hash.dig(:info, :email)&.downcase, freelancer.email
    assert_equal auth_hash.dig(:info, :name), freelancer.name
  end

  test "sign in with facebook" do
    auth_hash = Faker::Omniauth.unique.facebook.deep_symbolize_keys

    existing = create(:freelancer, email: auth_hash.dig(:info, :email)&.downcase)
    signed_in = Freelancer.find_or_create_from_auth_hash(auth_hash)

    assert_equal existing.email, signed_in.email
  end

  test "sign up with linkedin" do
    auth_hash = Faker::Omniauth.unique.linkedin.deep_symbolize_keys
    freelancer = Freelancer.find_or_create_from_auth_hash(auth_hash)

    assert_equal auth_hash.dig(:info, :email)&.downcase, freelancer.email
    assert_equal auth_hash.dig(:info, :name), freelancer.name
  end

  test "sign in with linkedin" do
    auth_hash = Faker::Omniauth.unique.linkedin.deep_symbolize_keys

    existing = create(:freelancer, email: auth_hash.dig(:info, :email)&.downcase)
    signed_in = Freelancer.find_or_create_from_auth_hash(auth_hash)

    assert_equal existing.email, signed_in.email
  end
end
