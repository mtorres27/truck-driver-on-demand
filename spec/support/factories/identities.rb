# == Schema Information
#
# Table name: identities
#
#  id              :integer          not null, primary key
#  loginable_type  :string
#  loginable_id    :integer          not null
#  provider        :string           not null
#  uid             :string           not null
#  last_sign_in_at :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :identity do
    factory :freelancer_google_identity do
      association :loginable, factory: :freelancer
      provider Faker::Omniauth.google["provider"]
      uid Faker::Omniauth.google["uid"]
    end
    factory :freelancer_facebook_identity do
      association :loginable, factory: :freelancer
      provider Faker::Omniauth.facebook["provider"]
      uid Faker::Omniauth.facebook["uid"]
    end
    factory :freelancer_linkedin_identity do
      association :loginable, factory: :freelancer
      provider Faker::Omniauth.linkedin["provider"]
      uid Faker::Omniauth.linkedin["uid"]
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
