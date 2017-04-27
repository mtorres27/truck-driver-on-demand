# == Schema Information
#
# Table name: projects
#
#  id                  :integer          not null, primary key
#  company_id          :integer
#  external_project_id :string
#  name                :string           not null
#  budget              :decimal(10, 2)   not null
#  starts_on           :datetime
#  duration            :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryGirl.define do
  factory :project do
    external_project_id { Faker::Code.unique.isbn }
    name { Faker::Company.unique.name }
    budget { Faker::Commerce.price }
  end
end
