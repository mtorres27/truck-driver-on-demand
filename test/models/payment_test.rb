# == Schema Information
#
# Table name: payments
#
#  id          :integer          not null, primary key
#  job_id      :integer
#  description :string           not null
#  amount      :decimal(10, 2)   not null
#  due_on      :datetime
#  paid_on     :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
