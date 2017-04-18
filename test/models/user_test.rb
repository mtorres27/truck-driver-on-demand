# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  email                    :string           not null
#  name                     :string           not null
#  street1                  :string           not null
#  street2                  :string
#  city                     :string           not null
#  state                    :string           not null
#  country                  :string           not null
#  zip                      :string           not null
#  latitude                 :decimal(9, 6)
#  longitude                :decimal(9, 6)
#  pay_unit_time_preference :string
#  pay_per_unit_time        :integer
#  tagline                  :string           not null
#  bio                      :text
#  markets                  :string
#  skills                   :string
#  years_of_experience      :integer          default("0"), not null
#  profile_views            :integer          default("0"), not null
#  projects_completed       :integer          default("0"), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase

  # https://github.com/pairshaped/postgis-on-rails-example
  test "near users" do
    far_user = create(
      :user,
      latitude: 40.000000,
      longitude: -77.000000
    )

    near_user = create(
      :user,
      latitude: 39.010000,
      longitude: -75.990000
    )

    near_users = User.near(39.000000, -76.000000).load

    assert_equal 1, near_users.size
    assert_equal near_user, near_users.first
  end

  test "do geocode" do
    user = create(
      :user,
      street1: "301 Front St W",
      city: "Toronto",
      state: "ON",
      country: "Canada",
      zip: "M5V 2T6"
    )

    user.do_geocode
    assert_equal 43.642605, user.latitude
    assert_equal -79.387123, user.longitude
  end

end
