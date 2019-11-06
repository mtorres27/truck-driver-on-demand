# frozen_string_literal: true

# == Schema Information
#
# Table name: driver_clearances
#
#  id          :bigint           not null, primary key
#  description :text
#  image       :string
#  image_data  :text
#  driver_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :driver_clearance do
    description { "MyText" }
    image { "MyString" }
    image_data { "MyText" }
    driver_id { 1 }
  end
end
