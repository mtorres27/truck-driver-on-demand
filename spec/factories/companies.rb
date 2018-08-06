# == Schema Information
#
# Table name: companies
#
#  id                        :integer          not null, primary key
#  token                     :string
#  name                      :string
#  address                   :string
#  formatted_address         :string
#  area                      :string
#  lat                       :decimal(9, 6)
#  lng                       :decimal(9, 6)
#  hq_country                :string
#  description               :string
#  avatar_data               :text
#  disabled                  :boolean          default(TRUE), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  messages_count            :integer          default(0), not null
#  company_reviews_count     :integer          default(0), not null
#  profile_header_data       :text
#  contract_preference       :string           default(NULL)
#  job_markets               :citext
#  technical_skill_tags      :citext
#  profile_views             :integer          default(0), not null
#  website                   :string
#  phone_number              :string
#  number_of_offices         :integer          default(0)
#  number_of_employees       :string
#  established_in            :integer
#  header_color              :string           default("FF6C38")
#  country                   :string
#  stripe_customer_id        :string
#  stripe_subscription_id    :string
#  stripe_plan_id            :string
#  subscription_cycle        :string
#  is_subscription_cancelled :boolean          default(FALSE)
#  subscription_status       :string
#  billing_period_ends_at    :datetime
#  last_4_digits             :string
#  card_brand                :string
#  exp_month                 :string
#  exp_year                  :string
#  header_source             :string           default("color")
#  sales_tax_number          :string
#  line2                     :string
#  city                      :string
#  state                     :string
#  postal_code               :string
#  job_types                 :citext
#  manufacturer_tags         :citext
#  plan_id                   :integer
#  is_trial_applicable       :boolean          default(TRUE)
#  waived_jobs               :integer          default(1)
#  registration_step         :string
#
# Indexes
#
#  index_companies_on_disabled              (disabled)
#  index_companies_on_job_markets           (job_markets)
#  index_companies_on_manufacturer_tags     (manufacturer_tags)
#  index_companies_on_name                  (name)
#  index_companies_on_plan_id               (plan_id)
#  index_companies_on_technical_skill_tags  (technical_skill_tags)
#  index_on_companies_loc                   (st_geographyfromtext((((('SRID=4326;POINT('::text || lng) || ' '::text) || lat) || ')'::text)))
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id)
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

    after(:build) do |company|
      company.company_users << FactoryBot.build(:company_user, :confirmed, role: :owner)
    end

    trait :registration_completed do
      registration_step "wicked_finish"
    end
  end
end
