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

require "rails_helper"

describe DriverTestResult, type: :model do
  describe "hooks" do
    describe "before create" do
      describe ".review_answers" do
        let(:driver_test) { create :driver_test }
        let(:question) { create :test_question, driver_test: driver_test, answer: 1 }
        let(:test_result) { build(:driver_test_result, driver_test: driver_test) }

        context "when correct answers" do
          before do
            test_result.answers = { question.id.to_s => "1" }
            test_result.save
          end

          it "sets correct score" do
            expect(test_result.score).to eq(1)
          end
        end

        context "when incorrect answers" do
          before do
            test_result.answers = { question.id.to_s => "2" }
            test_result.save
          end

          it "sets correct score" do
            expect(test_result.score).to eq(0)
          end
        end
      end
    end
  end
end
