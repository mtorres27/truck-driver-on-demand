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

class CompanyReview < ApplicationRecord

  RATING_ATTRS = %i[
    quality_of_information_provided
    communication
    materials_available_onsite
    promptness_of_payment
    overall_experience
  ].freeze

  include Reviewable

  belongs_to :driver, class_name: "User", foreign_key: "driver_id"
  belongs_to :company, counter_cache: true
  belongs_to :job

  audited

end
