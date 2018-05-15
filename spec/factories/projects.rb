# == Schema Information
#
# Table name: projects
#
#  id                  :integer          not null, primary key
#  company_id          :integer          not null
#  external_project_id :string
#  name                :string           not null
#  formatted_address   :string
#  lat                 :decimal(9, 6)
#  lng                 :decimal(9, 6)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryBot.define do
  factory :project do
    external_project_id { Faker::Code.unique.isbn }
    name { Faker::Company.unique.name }
  end
end
