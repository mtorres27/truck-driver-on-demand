# == Schema Information
#
# Table name: company_favourites
#
#  id            :integer          not null, primary key
#  freelancer_id :integer
#  company_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class CompanyFavouriteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
