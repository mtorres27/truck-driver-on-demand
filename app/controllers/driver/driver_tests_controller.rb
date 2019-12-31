# frozen_string_literal: true

class Driver::DriverTestsController < Driver::BaseController

  layout "clean"

  before_action :set_driver
  before_action :authorize_driver
  before_action :set_test

  def show; end

  def answer
    # rubocop:disable Metrics/LineLength
    if params[:driver_test_answers].nil? || params[:driver_test_answers][:questions].keys.count < @test.test_questions.count
      # rubocop:enable Metrics/LineLength
      flash.now[:error] = "Please answer all the questions before submitting the test."
      render :show
    else
      result = DriverTestResult.create!(
        driver_test: @test,
        driver: @driver,
        answers: params[:driver_test_answers][:questions],
      )
      redirect_to driver_driver_test_result_path(result)
    end
  end

  private

  def set_driver
    @driver = current_user
  end

  def authorize_driver
    authorize @driver
  end

  def set_test
    @test = DriverTest.find(params[:id])
  end

end
