# == Schema Information
#
# Table name: projects
#
#  id                  :integer          not null, primary key
#  company_id          :integer          not null
#  external_project_id :string
#  name                :string           not null
#  budget              :decimal(10, 2)   not null
#  starts_on           :date
#  duration            :integer
#  address             :string           not null
#  formatted_address   :string
#  area                :string
#  lat                 :decimal(9, 6)
#  lng                 :decimal(9, 6)
#  closed              :boolean          default(FALSE), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  currency            :string
#

FactoryGirl.define do
  factory :project do
    external_project_id { Faker::Code.unique.isbn }
    name { Faker::Company.unique.name }
    budget { Faker::Commerce.price }
    address { "#{Faker::Address.street_address}, #{Faker::Address.city}, #{Faker::Address.state_abbr} #{Faker::Address.zip}" }
  end
end
