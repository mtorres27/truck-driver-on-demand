# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  name       :string           not null
#  tagline    :string
#  address    :string
#  logo       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :company do
    email Faker::Internet.unique.email
    name Faker::Name.unique.name
  end
end
