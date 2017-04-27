# == Schema Information
#
# Table name: companies
#
#  id                :integer          not null, primary key
#  email             :string           not null
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
#  logo_data         :text
#  disabled          :boolean          default("false"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryGirl.define do
  factory :company do
    email { Faker::Internet.unique.email }
    name { Faker::Company.unique.name }
    contact_name { Faker::Name.unique.name }
  end
end
