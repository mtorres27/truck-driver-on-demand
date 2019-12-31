# frozen_string_literal: true

class Driver::DriverTestResultsController < Driver::BaseController

  layout "clean"

  before_action :set_driver
  before_action :set_test_results
  before_action :authorize_test_results

  def show
    @incorrect_answers = @test_results.answers.reject { |_key, hash| hash["correct"] }
  end

  private

  def set_driver
    @driver = current_user
  end

  def set_test_results
    @test_results = DriverTestResult.find(params[:id])
  end

  def authorize_test_results
    authorize @test_results
  end

end
