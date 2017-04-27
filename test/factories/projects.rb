# == Schema Information
#
# Table name: projects
#
#  id                  :integer          not null, primary key
#  external_project_id :string
#  name                :string           not null
#  budget              :decimal(10, 2)   not null
#  starts_on           :datetime
#  duration            :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryGirl.define do
  factory :project do
    external_project_id "MyString"
    name "MyString"
    budget "9.99"
    starts_on "2017-04-27 10:32:09"
    duration 1
  end
end
