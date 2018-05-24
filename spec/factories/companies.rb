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
#  disabled          :boolean          default(FALSE), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryBot.define do
  factory :company do
    email { Faker::Internet.unique.email }
    name { Faker::Company.unique.name }
    first_name { Faker::Name.unique.name }
    last_name { Faker::Name.unique.name }
    password "password"
    country [:es, :fi, :fr, :gb, :pt, :us].sample
    city { Faker::Address.city }
    state { Faker::Address.state}
    avatar { fixture_file_upload(Rails.root.join("spec", "fixtures", "image.png"), "image/png") }
    description { Faker::Lorem.sentence }
    established_in { Faker::Number.number(4) }
    number_of_employees { "eleven_to_one_hundred" }
    number_of_offices { Faker::Number.number(1) }
    website { Faker::Lorem.word }
    area { "USA" }
  end
end
