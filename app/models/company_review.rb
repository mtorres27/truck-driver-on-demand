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
  belongs_to :freelancer
  belongs_to :company
  belongs_to :job

  [
    :quality_of_information_provided,
    :communication,
    :materials_available_onsite,
    :promptness_of_payment,
    :overall_experience
  ].each do |attr|
    validates attr, inclusion: { in: 1..5 }
  end
end
