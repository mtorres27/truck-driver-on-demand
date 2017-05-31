# == Schema Information
#
# Table name: change_orders
#
#  id              :integer          not null, primary key
#  job_id          :integer          not null
#  amount          :decimal(10, 2)   not null
#  body            :text             not null
#  attachment_data :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class ChangeOrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
