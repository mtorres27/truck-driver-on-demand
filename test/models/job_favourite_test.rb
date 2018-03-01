# == Schema Information
#
# Table name: job_favourites
#
#  id            :integer          not null, primary key
#  freelancer_id :integer
#  job_id        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class JobFavouriteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
