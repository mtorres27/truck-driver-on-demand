# == Schema Information
#
# Table name: companies
#
#  id                    :integer          not null, primary key
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
#  saved_freelancers_ids :citext
#
# Indexes
#
#  index_companies_on_disabled              (disabled)
#  index_companies_on_job_markets           (job_markets)
#  index_companies_on_manufacturer_tags     (manufacturer_tags)
#  index_companies_on_name                  (name)
#  index_companies_on_technical_skill_tags  (technical_skill_tags)
#  index_on_companies_loc                   (st_geographyfromtext((((('SRID=4326;POINT('::text || lng) || ' '::text) || lat) || ')'::text)))
#

include ActionDispatch::TestProcess

FactoryBot.define do
  factory :company do
    name { Faker::Company.unique.name }
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

    trait :registration_completed do
      registration_step "wicked_finish"
    end
  end
end
