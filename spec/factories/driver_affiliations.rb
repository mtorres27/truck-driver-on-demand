# frozen_string_literal: true

# == Schema Information
#
# Table name: driver_affiliations
#
#  id         :bigint           not null, primary key
#  name       :string
#  image      :string
#  driver_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  image_data :text
#

FactoryBot.define do
  factory :driver_affiliation do
    name { "MyString" }
    image { "MyString" }
    driver_id { 1 }
  end
end
