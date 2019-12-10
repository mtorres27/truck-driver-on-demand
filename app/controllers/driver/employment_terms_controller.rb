# frozen_string_literal: true

class Driver::EmploymentTermsController < Driver::BaseController

  layout "clean"
  
  before_action :set_driver
  before_action :authorize_driver

  def index; end

  private

  def set_driver
    @driver = current_user
  end

  def authorize_driver
    authorize @driver
  end

end
