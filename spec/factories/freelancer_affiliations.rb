# == Schema Information
#
# Table name: freelancer_affiliations
#
#  id            :integer          not null, primary key
#  name          :string
#  image         :string
#  freelancer_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  image_data    :text
#

FactoryBot.define do
  factory :freelancer_affiliation do
    name "MyString"
    image "MyString"
    freelancer_id 1
  end
end
