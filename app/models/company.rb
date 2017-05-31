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
#  disabled          :boolean          default("false"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Company < ApplicationRecord
  include Loginable
  include Geocodable
  include Disableable
  include AvatarUploader[:avatar]

  has_many :identities, as: :loginable, dependent: :destroy
  has_many :projects, -> { order(updated_at: :desc) }, dependent: :destroy
  has_many :messages, -> { order(created_at: :desc) }, as: :authorable

  # We want to populate both name and contact_name on sign up
  before_validation :set_contact_name, on: :create
  def set_contact_name
    self.contact_name = name unless contact_name
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
