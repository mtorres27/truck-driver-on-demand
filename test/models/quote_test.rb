# == Schema Information
#
# Table name: quotes
#
#  id              :integer          not null, primary key
#  applicant_id    :integer          not null
#  state           :string           default("pending"), not null
#  amount          :decimal(10, 2)   not null
#  pay_type        :string           default("fixed"), not null
#  body            :text
#  attachment_data :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class QuoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
