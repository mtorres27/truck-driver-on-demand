# frozen_string_literal: true

class Driver::OnboardingProcessController < Driver::BaseController

  layout 'clean', only: [:complete_profile]

  before_action :set_driver
  before_action :authorize_driver

  def index; end

  def complete_profile; end

  def complete_profile_update
    if @driver.update(complete_profile_params)
      @driver.driver_profile.update!(completed_profile: true)
      flash[:notice] = 'Profile Completed'
      redirect_to driver_onboarding_process_index_path
    else
      render :complete_profile
    end
  end

  def cvor_abstract; end

  def upload_cvor_abstract
    if @driver.update(cvor_abstract_params)
      @driver.driver_profile.update!(cvor_abstract_uploaded: true)
      flash[:notice] = 'CVOR Abstract uploaded'
      redirect_to driver_onboarding_process_index_path
    else
      render :cvor_abstract
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
      driver_profile_attributes: [
        :id,
        :years_of_experience,
        :address_line1,
        :address_line2,
        :city,
        :postal_code,
        :driver_type,
        :business_name,
        :hst_number,
        :avatar,
        :background_check,
      ],
    )
  end

  def cvor_abstract_params
    params.require(:driver).permit(
      :id,
      :cvor_abstract_form,
      driver_profile_attributes: [
        :id,
        :cvor_abstract
      ],
    )
  end

end
