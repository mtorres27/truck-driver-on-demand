# == Schema Information
#
# Table name: attachments
#
#  id         :integer          not null, primary key
#  file_data  :string
#  job_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  title      :string
#

require 'test_helper'

class AttachmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
