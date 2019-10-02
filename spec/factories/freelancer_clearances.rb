# == Schema Information
#
# Table name: freelancer_clearances
#
#  id            :integer          not null, primary key
#  description   :text
#  image         :string
#  image_data    :text
#  freelancer_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :freelancer_clearance do
    description { "MyText" }
    image { "MyString" }
    image_data { "MyText" }
    freelancer_id { 1 }
  end
end
