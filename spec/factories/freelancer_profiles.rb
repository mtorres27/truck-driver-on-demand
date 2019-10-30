# frozen_string_literal: true

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
#  tagline                  :string
#  bio                      :text
#  job_markets              :citext
#  years_of_experience      :integer          default(0), not null
#  profile_views            :integer          default(0), not null
#  available                :boolean          default(TRUE), not null
#  disabled                 :boolean          default(TRUE), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  freelancer_reviews_count :integer          default(0), not null
#  technical_skill_tags     :citext
#  verified                 :boolean          default(FALSE)
#  country                  :string
#  freelancer_team_size     :string
#  freelancer_type          :string
#  line2                    :string
#  state                    :string
#  postal_code              :string
#  service_areas            :string
#  city                     :string
#  profile_score            :integer
#  valid_driver             :boolean
#  own_tools                :boolean
#  company_name             :string
#  job_functions            :citext
#  manufacturer_tags        :citext
#  registration_step        :string
#  province                 :string
#  freelancer_id            :integer
#  requested_verification   :boolean          default(FALSE)
#  pay_unit_time_preference :string
#  pay_rate                 :float
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
# rubocop:disable Metrics/LineLength
#  index_on_freelancer_profiles_loc                   (st_geographyfromtext((((('SRID=4326;POINT('::text || lng) || ' '::text) || lat) || ')'::text)))
#  index_on_freelancers_loc                           (st_geographyfromtext((((('SRID=4326;POINT('::text || lng) || ' '::text) || lat) || ')'::text)))
# rubocop:enable Metrics/LineLength
#

FactoryBot.define do
  factory :freelancer_profile do
    country { %i[es fi fr gb pt us].sample }
    city { Faker::Address.city }
    state { Faker::Address.state }
    bio { Faker::Lorem }
    tagline { Faker::Lorem }
    avatar { fixture_file_upload(Rails.root.join("spec", "fixtures", "image.png"), "image/png") }

    trait :registration_completed do
      registration_step { "wicked_finish" }
    end
  end
end
