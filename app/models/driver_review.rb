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

class DriverReview < ApplicationRecord

  RATING_ATTRS = %i[
    availability
    communication
    adherence_to_schedule
    skill_and_quality_of_work
    overall_experience
  ].freeze

  include Reviewable

  belongs_to :company
  belongs_to :driver, class_name: "User", foreign_key: "driver_id"
  belongs_to :job

  audited

end
