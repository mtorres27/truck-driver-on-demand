# frozen_string_literal: true

class Driver::OnboardingProcessController < Driver::BaseController

  layout "clean", only: [:complete_profile]

  before_action :set_driver
  before_action :authorize_driver

  def index; end

  def complete_profile; end

  def complete_profile_update
    if @driver.update(complete_profile_params)
      @driver.driver_profile.update!(completed_profile: true)
      flash[:notice] = "Profile Completed"
      redirect_to driver_onboarding_process_index_path
    else
      render :complete_profile
    end
  end

  def cvor_abstract; end

  def upload_cvor_abstract
    if @driver.update(cvor_abstract_params)
      @driver.driver_profile.update!(cvor_abstract_uploaded: true)
      flash[:notice] = "CVOR Abstract uploaded"
      redirect_to driver_onboarding_process_index_path
    else
      render :cvor_abstract
    end
  end

  def driver_abstract; end

  def upload_driver_abstract
    if @driver.update(driver_abstract_params)
      @driver.driver_profile.update!(driver_abstract_uploaded: true)
      flash[:notice] = "Driver Abstract uploaded"
      redirect_to driver_onboarding_process_index_path
    else
      render :driver_abstract
    end
  end

  def drivers_license
    @driver.driver_profile.build_drivers_license if @driver.driver_profile.drivers_license.nil?
  end

  def upload_drivers_license
    if @driver.update(drivers_license_params)
      @driver.driver_profile.update!(drivers_license_uploaded: true)
      flash[:notice] = "Drivers License uploaded"
      redirect_to driver_onboarding_process_index_path
    else
      render :drivers_license
    end
  end

  private

  def set_driver
    @driver = current_user
  end

  def authorize_driver
    authorize @driver
  end

  def complete_profile_params
    params.require(:driver).permit(
      :id,
      :complete_profile_form,
      driver_profile_attributes: %i[
        id
        years_of_experience
        driving_school
        address_line1
        address_line2
        city
        postal_code
        driver_type
        business_name
        hst_number
        avatar
        background_check
      ],
    )
  end

  def cvor_abstract_params
    params.require(:driver).permit(
      :id,
      :cvor_abstract_form,
      driver_profile_attributes: %i[
        id
        cvor_abstract
      ],
    )
  end

  def driver_abstract_params
    params.require(:driver).permit(
      :id,
      :driver_abstract_form,
      driver_profile_attributes: %i[
        id
        driver_abstract
      ],
    )
  end

  def drivers_license_params
    params.require(:driver).permit(
      :id,
      :driver_abstract_form,
      driver_profile_attributes: [
        :id,
        drivers_license_attributes: %i[
          id
          license
          license_number
          exp_date
          license_class
        ]
      ],
    )
  end

end
