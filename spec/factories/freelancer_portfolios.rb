# == Schema Information
#
# Table name: freelancer_portfolios
#
#  id            :integer          not null, primary key
#  name          :text
#  image         :string
#  image_data    :text
#  freelancer_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :freelancer_portfolio do
    name { "MyText" }
    image { "MyString" }
    image_data { "MyText" }
    freelancer_id { 1 }
  end
end
