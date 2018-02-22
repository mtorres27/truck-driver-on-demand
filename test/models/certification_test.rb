# == Schema Information
#
# Table name: certifications
#
#  id               :integer          not null, primary key
#  freelancer_id    :integer
#  certificate      :text
#  name             :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  thumbnail        :text
#  certificate_data :text
#

require 'test_helper'

class CertificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
