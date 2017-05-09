# == Schema Information
#
# Table name: applicants
#
#  id            :integer          not null, primary key
#  job_id        :integer
#  freelancer_id :integer
#  accepted      :boolean          default("false"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class ApplicantTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
