# frozen_string_literal: true

# == Schema Information
#
# Table name: companies
#
#  id                    :bigint           not null, primary key
#  token                 :string
#  name                  :string
#  address               :string
#  formatted_address     :string
#  area                  :string
#  lat                   :decimal(9, 6)
#  lng                   :decimal(9, 6)
#  hq_country            :string
#  description           :string
#  avatar_data           :text
#  disabled              :boolean          default(TRUE), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  messages_count        :integer          default(0), not null
#  company_reviews_count :integer          default(0), not null
#  profile_header_data   :text
#  contract_preference   :string           default(NULL)
#  job_markets           :citext
#  technical_skill_tags  :citext
#  profile_views         :integer          default(0), not null
#  website               :string
#  phone_number          :string
#  number_of_offices     :integer          default(0)
#  number_of_employees   :string
#  established_in        :integer
#  header_color          :string           default("FF6C38")
#  country               :string
#  header_source         :string           default("default")
#  sales_tax_number      :string
#  line2                 :string
#  city                  :string
#  state                 :string
#  postal_code           :string
#  job_types             :citext
#  manufacturer_tags     :citext
#  registration_step     :string
#  saved_drivers_ids     :citext
#

FactoryBot.define do
  factory :company do
    name { Faker::Company.unique.name }
    country { %i[es fi fr gb pt us].sample }
    city { Faker::Address.city }
    state { Faker::Address.state }
    avatar { fixture_file_upload(Rails.root.join("spec", "fixtures", "image.png"), "image/png") }
    description { Faker::Lorem.sentence }
    established_in { Faker::Number.number(4) }
    number_of_employees { "eleven_to_one_hundred" }
    number_of_offices { Faker::Number.number(1) }
    website { Faker::Lorem.word }
    area { "USA" }

    trait :registration_completed do
      registration_step { "wicked_finish" }
    end
  end
end
