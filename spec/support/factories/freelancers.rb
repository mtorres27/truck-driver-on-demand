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
#  keywords                 :citext
#  years_of_experience      :integer          default(0), not null
#  profile_views            :integer          default(0), not null
#  projects_completed       :integer          default(0), not null
#  available                :boolean          default(TRUE), not null
#  disabled                 :boolean          default(FALSE), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

FactoryBot.define do
  factory :freelancer do
    email { Faker::Internet.unique.email }
    name { Faker::Name.unique.name }
  end
end
