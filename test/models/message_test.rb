# == Schema Information
#
# Table name: messages
#
#  id              :integer          not null, primary key
#  job_id          :integer
#  authorable_type :string
#  authorable_id   :integer
#  message         :text
#  attachment_data :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
