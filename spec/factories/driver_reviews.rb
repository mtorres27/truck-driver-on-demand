# frozen_string_literal: true

# == Schema Information
#
# Table name: driver_reviews
#
#  id                        :bigint           not null, primary key
#  driver_id                 :bigint
#  company_id                :bigint
#  job_id                    :bigint
#  availability              :integer          not null
#  communication             :integer          not null
#  adherence_to_schedule     :integer          not null
#  skill_and_quality_of_work :integer          not null
#  overall_experience        :integer          not null
#  comments                  :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

FactoryBot.define do
  factory :driver_review do
    driver { nil }
    company { nil }
    job { nil }
    comments { "MyText" }
  end
end
