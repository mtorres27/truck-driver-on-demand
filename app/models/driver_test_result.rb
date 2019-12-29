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

class DriverTestResult < ApplicationRecord

  belongs_to :driver_test
  belongs_to :driver, class_name: "User", foreign_key: "driver_id"

  before_create :review_answers

  private

  def review_answers
    correct_answers = 0
    answers.keys.each do |question_id|
      correct_answer = TestQuestion.find(question_id).answer
      given_answer = answers[question_id].to_i
      answers[question_id] = { checked: given_answer, correct: correct_answer == given_answer }
      correct_answers += 1 if correct_answer == given_answer
    end
    self.score = correct_answers.to_f / driver_test.test_questions.count
  end

end
