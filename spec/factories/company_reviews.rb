# frozen_string_literal: true

# == Schema Information
#
# Table name: company_reviews
#
#  id                              :bigint           not null, primary key
#  company_id                      :bigint
#  driver_id                       :bigint
#  job_id                          :bigint
#  quality_of_information_provided :integer          not null
#  communication                   :integer          not null
#  materials_available_onsite      :integer          not null
#  promptness_of_payment           :integer          not null
#  overall_experience              :integer          not null
#  comments                        :text
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#

FactoryBot.define do
  factory :company_review do
    company { nil }
    driver { nil }
    job { nil }
    promptness_of_payment { "MyString" }
    material_available_on_site { "MyString" }
    communication { "MyString" }
    comments { "MyString" }
  end
end
