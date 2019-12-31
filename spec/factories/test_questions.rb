# frozen_string_literal: true

# == Schema Information
#
# Table name: test_questions
#
#  id             :bigint           not null, primary key
#  driver_test_id :bigint           not null
#  question       :string           not null
#  options        :jsonb            not null
#  answer         :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryBot.define do
  factory :test_question do
    question { "Some question" }
    options { [{ text: "Option 1", index: 1 }, { text: "Option 2", index: 2 }] }
    answer { 1 }
    driver_test
  end
end
