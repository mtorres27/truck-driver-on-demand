# frozen_string_literal: true

# == Schema Information
#
# Table name: identities
#
#  id              :bigint           not null, primary key
#  loginable_type  :string           not null
#  loginable_id    :bigint           not null
#  provider        :string           not null
#  uid             :string           not null
#  last_sign_in_at :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :identity do
    factory :driver_google_identity do
      association :loginable, factory: :driver
      provider { Faker::Omniauth.google["provider"] }
      uid { Faker::Omniauth.google["uid"] }
    end
    factory :driver_facebook_identity do
      association :loginable, factory: :driver
      provider { Faker::Omniauth.facebook["provider"] }
      uid { Faker::Omniauth.facebook["uid"] }
    end
    factory :driver_linkedin_identity do
      association :loginable, factory: :driver
      provider { Faker::Omniauth.linkedin["provider"] }
      uid { Faker::Omniauth.linkedin["uid"] }
    end
    # factory :company_google_identity do
    #   association :loginable, factory: :company
    #   provider Faker::Omniauth.google["provider"]
    #   uid Faker::Omniauth.google["uid"]
    # end
    # factory :company_facebook_identity do
    #   association :loginable, factory: :company
    #   provider Faker::Omniauth.facebook["provider"]
    #   uid Faker::Omniauth.facebook["uid"]
    # end
    # factory :company_linkedin_identity do
    #   association :loginable, factory: :company
    #   provider Faker::Omniauth.linkedin["provider"]
    #   uid Faker::Omniauth.linkedin["uid"]
    # end
  end
end
