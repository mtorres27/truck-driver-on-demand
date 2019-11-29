# frozen_string_literal: true

class Driver::BaseController < ApplicationController

  layout "driver/layouts/application"
  before_action :authenticate_user!
  before_action :redirect_if_not_driver

  helper_method :current_driver_profile

  private

  def current_driver_profile
    @current_driver_profile ||= current_user&.driver_profile
  end

  def redirect_if_not_driver
    redirect_to root_path unless current_user&.driver?
  end

  def current_driver_registering?
    !current_user&.driver_profile&.registration_completed?
  end

end
