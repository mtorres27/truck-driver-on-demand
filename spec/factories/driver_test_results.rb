# frozen_string_literal: true

# == Schema Information
#
# Table name: driver_test_results
#
#  id             :bigint           not null, primary key
#  driver_test_id :bigint           not null
#  driver_id      :bigint           not null
#  answers        :jsonb
#  score          :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryBot.define do
  factory :driver_test_result do
    driver_test
    driver
  end
end
