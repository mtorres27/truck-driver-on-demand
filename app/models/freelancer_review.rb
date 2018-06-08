# == Schema Information
#
# Table name: freelancer_reviews
#
#  id                        :integer          not null, primary key
#  freelancer_id             :integer
#  company_id                :integer
#  job_id                    :integer
#  availability              :integer          not null
#  communication             :integer          not null
#  adherence_to_schedule     :integer          not null
#  skill_and_quality_of_work :integer          not null
#  overall_experience        :integer          not null
#  comments                  :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class FreelancerReview < ApplicationRecord
  RATING_ATTRS = [
    :availability,
    :communication,
    :adherence_to_schedule,
    :skill_and_quality_of_work,
    :overall_experience
  ]

  include Reviewable

  belongs_to :company
  belongs_to :freelancer, counter_cache: true, class_name: 'FreelancerData', foreign_key: 'freelancer_id'
  belongs_to :job

  schema_validations auto_create: false

  audited
end
