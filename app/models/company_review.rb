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

class CompanyReview < ApplicationRecord
  RATING_ATTRS = [
    :quality_of_information_provided,
    :communication,
    :materials_available_onsite,
    :promptness_of_payment,
    :overall_experience
  ]

  include Reviewable

  belongs_to :freelancer
  belongs_to :company, counter_cache: true
  belongs_to :job

  schema_validations auto_create: false

  audited
end
