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
#  disabled                 :boolean          default("false"), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

FactoryGirl.define do
  factory :freelancer do
    email Faker::Internet.unique.email
    name Faker::Name.unique.name
  end
end
