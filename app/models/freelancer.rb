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

class Freelancer < ApplicationRecord
  include Loginable
  include Geocodable

  has_many :identities, as: :loginable

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  # This SQL needs to stay exactly in sync with it's related index (index_on_freelancers_location)
  # otherwise the index won't be used. (don't even add whitespace!)
  # https://github.com/pairshaped/postgis-on-rails-example
  scope :near, -> (lat, lng, distance_in_meters = 2000) {
    where(%{
      ST_DWithin(
        ST_GeographyFromText(
          'SRID=4326;POINT(' || freelancers.lng || ' ' || freelancers.lat || ')'
        ),
        ST_GeographyFromText('SRID=4326;POINT(%f %f)'),
        %d
      )
    } % [lng, lat, distance_in_meters])
  }
end
