# frozen_string_literal: true

# == Schema Information
#
# Table name: driver_profiles
#
#  id                       :bigint           not null, primary key
#  token                    :string
#  avatar_data              :text
#  tagline                  :string
#  bio                      :text
#  profile_views            :integer          default(0), not null
#  available                :boolean          default(TRUE), not null
#  disabled                 :boolean          default(TRUE), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  driver_reviews_count     :integer          default(0), not null
#  verified                 :boolean          default(FALSE)
#  driver_type              :string
#  postal_code              :string
#  service_areas            :string
#  city                     :string
#  profile_score            :integer
#  registration_step        :string
#  driver_id                :integer
#  requested_verification   :boolean          default(FALSE)
#  province                 :string
#  transmission_and_speed   :citext
#  freight_type             :citext
#  other_skills             :citext
#  vehicle_type             :citext
#  truck_type               :citext
#  trailer_type             :citext
#  address_line1            :string
#  address_line2            :string
#  background_check_data    :text
#  completed_profile        :boolean          default(FALSE)
#  years_of_experience      :string
#  business_name            :string
#  hst_number               :string
#  cvor_abstract_data       :text
#  cvor_abstract_uploaded   :boolean          default(FALSE)
#  driver_abstract_data     :text
#  driver_abstract_uploaded :boolean          default(FALSE)
#  driving_school           :string
#  drivers_license_uploaded :boolean          default(FALSE)
#  resume_data              :text
#  resume_uploaded          :boolean          default(FALSE)
#  accept_wsib              :boolean          default(FALSE)
#

FactoryBot.define do
  factory :driver_profile do
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
