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

FactoryGirl.define do
  factory :user do
    email Faker::Internet.unique.email
    name Faker::Name.unique.name
    street1 Faker::Address.street_address
    city Faker::Address.city
    state Faker::Address.state
    country Faker::Address.country
    zip Faker::Address.zip
    tagline Faker::Company.catch_phrase
  end
end
