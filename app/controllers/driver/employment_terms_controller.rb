# frozen_string_literal: true

class Driver::EmploymentTermsController < Driver::BaseController

  layout "clean"
  
  before_action :set_driver
  before_action :authorize_driver

  def index; end

  def wsib; end

  def accept_wsib
    if @driver.update(wsib_params)
      redirect_to driver_employment_terms_path
    else
      render :wsib
    end
  end

  private

  def set_driver
    @driver = current_user
  end

  def authorize_driver
    authorize @driver
  end

  def wsib_params
    params.require(:driver).permit(
      :id,
      driver_profile_attributes: %i[
        id
        accept_wsib
      ],
    )
  end

end
