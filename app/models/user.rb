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

class User < ApplicationRecord
  include Geocodable

  # This SQL needs to stay exactly in sync with it's related index (index_on_users_location)
  # otherwise the index won't be used. (don't even add whitespace!)
  # https://github.com/pairshaped/postgis-on-rails-example
  scope :near, -> (latitude, longitude, distance_in_meters = 2000) {
    where(%{
      ST_DWithin(
        ST_GeographyFromText(
          'SRID=4326;POINT(' || users.longitude || ' ' || users.latitude || ')'
        ),
        ST_GeographyFromText('SRID=4326;POINT(%f %f)'),
        %d
      )
    } % [longitude, latitude, distance_in_meters])
  }
end
