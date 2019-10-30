# frozen_string_literal: true

# == Schema Information
#
# Table name: freelancer_insurances
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  freelancer_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  image         :string
#  image_data    :text
#

FactoryBot.define do
  factory :freelancer_insurance do
    name { "MyString" }
    freelancer_id { 1 }
  end
end
