# == Schema Information
#
# Table name: featured_projects
#
#  id         :integer          not null, primary key
#  company_id :integer
#  name       :string
#  file       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  file_data  :string
#

require 'test_helper'

class FeaturedProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
