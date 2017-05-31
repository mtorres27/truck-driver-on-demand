# == Schema Information
#
# Table name: admins
#
#  id         :integer          not null, primary key
#  token      :string
#  email      :citext           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class AdminTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
