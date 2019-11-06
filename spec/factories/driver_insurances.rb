# frozen_string_literal: true

# == Schema Information
#
# Table name: driver_insurances
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  driver_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  image       :string
#  image_data  :text
#

FactoryBot.define do
  factory :driver_insurance do
    name { "MyString" }
    driver_id { 1 }
  end
end
