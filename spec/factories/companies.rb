# == Schema Information
#
# Table name: companies
#
#  id                        :integer          not null, primary key
#  token                     :string
#  email                     :citext           not null
#  name                      :string           not null
#  contact_name              :string           not null
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
#  encrypted_password        :string           default(""), not null
#  reset_password_token      :string
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :inet
#  last_sign_in_ip           :inet
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
#  header_color              :string           default("FF6C38")
#  country                   :string
#  confirmation_token        :string
#  confirmed_at              :datetime
#  confirmation_sent_at      :datetime
#  header_source             :string           default("color")
#  province                  :string
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
#

FactoryBot.define do
  factory :company do
    email { Faker::Internet.unique.email }
    name { Faker::Company.unique.name }
    first_name { Faker::Name.unique.name }
    last_name { Faker::Name.unique.name }
    contact_name { Faker::Name.unique.name }
    password "password"
    password_confirmation { 'password' }
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
