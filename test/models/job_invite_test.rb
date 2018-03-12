# == Schema Information
#
# Table name: job_invites
#
#  id            :integer          not null, primary key
#  job_id        :integer
#  freelancer_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class JobInviteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
