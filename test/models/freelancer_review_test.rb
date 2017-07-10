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

require 'test_helper'

class FreelancerReviewTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
