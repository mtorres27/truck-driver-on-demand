# frozen_string_literal: true

# == Schema Information
#
# Table name: company_reviews
#
#  id                              :integer          not null, primary key
#  company_id                      :integer
#  freelancer_id                   :integer
#  job_id                          :integer
#  quality_of_information_provided :integer          not null
#  communication                   :integer          not null
#  materials_available_onsite      :integer          not null
#  promptness_of_payment           :integer          not null
#  overall_experience              :integer          not null
#  comments                        :text
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#
# Indexes
#
#  index_company_reviews_on_company_id     (company_id)
#  index_company_reviews_on_freelancer_id  (freelancer_id)
#  index_company_reviews_on_job_id         (job_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (freelancer_id => users.id)
#  fk_rails_...  (job_id => jobs.id)
#

FactoryBot.define do
  factory :company_review do
    company { nil }
    freelancer { nil }
    job { nil }
    promptness_of_payment { "MyString" }
    material_available_on_site { "MyString" }
    communication { "MyString" }
    comments { "MyString" }
  end
end
