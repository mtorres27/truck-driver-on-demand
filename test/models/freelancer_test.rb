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
#  job_markets              :citext
#  years_of_experience      :integer          default(0), not null
#  profile_views            :integer          default(0), not null
#  projects_completed       :integer          default(0), not null
#  available                :boolean          default(TRUE), not null
#  disabled                 :boolean          default(TRUE), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  messages_count           :integer          default(0), not null
#  freelancer_reviews_count :integer          default(0), not null
#  technical_skill_tags     :citext
#  profile_header_data      :text
#  verified                 :boolean          default(FALSE)
#  encrypted_password       :string           default(""), not null
#  reset_password_token     :string
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer          default(0), not null
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :inet
#  last_sign_in_ip          :inet
#  header_color             :string           default("FF6C38")
#  country                  :string
#  confirmation_token       :string
#  confirmed_at             :datetime
#  confirmation_sent_at     :datetime
#  freelancer_team_size     :string
#  freelancer_type          :string
#  header_source            :string           default("color")
#  stripe_account_id        :string
#  stripe_account_status    :text
#  currency                 :string
#  sales_tax_number         :string
#  line2                    :string
#  state                    :string
#  postal_code              :string
#  service_areas            :string
#  city                     :string
#  phone_number             :string
#  special_avj_fees         :decimal(10, 2)
#  job_types                :citext
#  job_functions            :citext
#  manufacturer_tags        :citext
#

require "test_helper"

class FreelancerTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

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

    near_freelancers = Freelancer.nearby(39.000000, -76.000000).load

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

end
