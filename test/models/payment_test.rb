# == Schema Information
#
# Table name: payments
#
#  id              :integer          not null, primary key
#  company_id      :integer          not null
#  job_id          :integer          not null
#  description     :string           not null
#  amount          :decimal(10, 2)   not null
#  issued_on       :date
#  paid_on         :date
#  attachment_data :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  tax_amount      :decimal(10, 2)
#  total_amount    :decimal(10, 2)
#  avj_fees        :decimal(10, 2)
#

require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
