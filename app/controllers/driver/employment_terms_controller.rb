# frozen_string_literal: true

class Driver::EmploymentTermsController < Driver::BaseController

  layout "clean"

  before_action :set_driver
  before_action :authorize_driver

  def index; end

  def health_and_safety; end

  def accept_health_and_safety
    if @driver.update(health_and_safety_params)
      redirect_to driver_employment_terms_path
    else
      render :health_and_safety
    end
  end

  def wsib; end

  def accept_wsib
    if @driver.update(wsib_params)
      redirect_to driver_employment_terms_path
    else
      render :wsib
    end
  end

  def excess_hours; end

  def accept_excess_hours
    if @driver.update(excess_hours_params)
      redirect_to driver_employment_terms_path
    else
      render :excess_hours
    end
  end

  def terms_and_conditions; end

  def accept_terms_and_conditions
    if @driver.update(terms_and_conditions_params)
      redirect_to driver_employment_terms_path
    else
      render :terms_and_conditions
    end
  end

  def previously_registered; end

  def previously_registered_answer
    if @driver.update(previously_registered_params)
      redirect_to driver_employment_terms_path
    else
      render :previously_registered
    end
  end

  private

  def set_driver
    @driver = current_user
  end

  def authorize_driver
    authorize @driver
  end

  def health_and_safety_params
    params.require(:driver).permit(
      :id,
      driver_profile_attributes: %i[
        id
        accept_health_and_safety
      ],
    )
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

  def excess_hours_params
    params.require(:driver).permit(
      :id,
      driver_profile_attributes: %i[
        id
        accept_excess_hours
      ],
    )
  end

  def terms_and_conditions_params
    params.require(:driver).permit(
      :id,
      driver_profile_attributes: %i[
        id
        accept_terms_and_conditions
      ],
    )
  end

  def previously_registered_params
    params.require(:driver).permit(
      :id,
      driver_profile_attributes: %i[
        id
        previously_registered_with_tpi
      ],
    )
  end

end
