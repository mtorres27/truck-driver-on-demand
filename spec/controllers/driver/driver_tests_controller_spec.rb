# frozen_string_literal: true

require "rails_helper"

describe Driver::DriverTestsController, type: :controller do
  describe "POST answer" do
    login_driver

    let(:driver_test) { create :driver_test }
    let(:question) { create :test_question, driver_test: driver_test, answer: 1 }

    context "when correct answers" do
      let(:params) do
        {
          id: driver_test.id,
          driver_test_answers: {
            questions: {
              question.id.to_s => "1",
            },
          },
        }
      end

      it "creates test_result" do
        expect { post :answer, params: params }.to change(DriverTestResult, :count).by(1)
      end

      it "gives test_result correct score" do
        post :answer, params: params
        test_result = DriverTestResult.last
        expect(test_result.score).to eq(1)
      end
    end

    context "when incorrect answers" do
      let(:params) do
        {
          id: driver_test.id,
          driver_test_answers: {
            questions: {
              question.id.to_s => "2",
            },
          },
        }
      end

      it "creates test_result" do
        expect { post :answer, params: params }.to change(DriverTestResult, :count).by(1)
      end

      it "gives test_result correct score" do
        post :answer, params: params
        test_result = DriverTestResult.last
        expect(test_result.score).to eq(0)
      end
    end
  end
end
