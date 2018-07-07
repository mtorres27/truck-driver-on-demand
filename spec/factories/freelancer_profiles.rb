# == Schema Information
#
# Table name: freelancer_profiles
#
#  id                       :integer          not null, primary key
#  token                    :string
#  avatar_data              :text
#  address                  :string
#  formatted_address        :string
#  area                     :string
#  lat                      :decimal(9, 6)
#  lng                      :decimal(9, 6)
#  pay_unit_time_preference :string
#  pay_per_unit_time        :string
#  tagline                  :string
#  bio                      :text
#  job_markets              :citext
#  years_of_experience      :integer          default(0), not null
#  profile_views            :integer          default(0), not null
#  projects_completed       :integer          default(0), not null
#  available                :boolean          default(TRUE), not null
#  disabled                 :boolean          default(TRUE), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  freelancer_reviews_count :integer          default(0), not null
#  technical_skill_tags     :citext
#  profile_header_data      :text
#  verified                 :boolean          default(FALSE)
#  header_color             :string           default("FF6C38")
#  country                  :string
#  freelancer_team_size     :string
#  freelancer_type          :string
#  header_source            :string           default("color")
#  stripe_account_id        :string
#  stripe_account_status    :text
#  currency                 :string
#  sales_tax_number         :string
#  line2                    :string
#  state                    :string
#  postal_code              :string
#  service_areas            :string
#  city                     :string
#  phone_number             :string
#  profile_score            :integer
#  valid_driver             :boolean
#  own_tools                :boolean
#  company_name             :string
#  job_types                :citext
#  job_functions            :citext
#  manufacturer_tags        :citext
#  special_avj_fees         :decimal(10, 2)
#  avj_credit               :decimal(10, 2)
#  registration_step        :string
#  province                 :string
#  freelancer_id            :integer
#
# Indexes
#
#  index_freelancer_profiles_on_area                  (area)
#  index_freelancer_profiles_on_available             (available)
#  index_freelancer_profiles_on_disabled              (disabled)
#  index_freelancer_profiles_on_freelancer_id         (freelancer_id)
#  index_freelancer_profiles_on_job_functions         (job_functions)
#  index_freelancer_profiles_on_job_markets           (job_markets)
#  index_freelancer_profiles_on_manufacturer_tags     (manufacturer_tags)
#  index_freelancer_profiles_on_technical_skill_tags  (technical_skill_tags)
#  index_on_freelancer_profiles_loc                   (st_geographyfromtext((((('SRID=4326;POINT('::text || lng) || ' '::text) || lat) || ')'::text)))
#  index_on_freelancers_loc                           (st_geographyfromtext((((('SRID=4326;POINT('::text || lng) || ' '::text) || lat) || ')'::text)))
#

FactoryBot.define do
  factory :freelancer_profile do
    country [:es, :fi, :fr, :gb, :pt, :us].sample
    city { Faker::Address.city }
    state { Faker::Address.state }
    bio { Faker::Lorem }
    tagline { Faker::Lorem }
    avatar { fixture_file_upload(Rails.root.join("spec", "fixtures", "image.png"), "image/png") }
  end
end
