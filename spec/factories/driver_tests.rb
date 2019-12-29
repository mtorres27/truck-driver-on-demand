# frozen_string_literal: true

# == Schema Information
#
# Table name: driver_tests
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :driver_test do
    name { Faker::Name.unique.name }
  end
end
