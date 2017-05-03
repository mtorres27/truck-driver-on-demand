# == Schema Information
#
# Table name: projects
#
#  id                  :integer          not null, primary key
#  company_id          :integer
#  external_project_id :string
#  name                :string           not null
#  budget              :decimal(10, 2)   not null
#  starts_on           :date
#  duration            :integer
#  address             :string           not null
#  formatted_address   :string
#  area                :string
#  lat                 :decimal(9, 6)
#  lng                 :decimal(9, 6)
#  closed              :boolean          default("false"), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
