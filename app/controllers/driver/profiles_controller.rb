# frozen_string_literal: true

class Driver::ProfilesController < Driver::BaseController

  def show
    @driver = if params[:id]
                Driver.find(params[:id])
              else
                current_user
              end
    authorize @driver
  end

  def edit
    @driver = current_user
    authorize @driver
  end

  def update
    @driver = current_user
    authorize @driver

    if @driver.update(driver_params)
      redirect_to driver_profile_path(@driver)
    else
      render :edit
    end
  end

  private

  # rubocop:disable Metrics/MethodLength
  def driver_params
    params.require(:driver).permit(
      :id,
      :first_name,
      :last_name,
      :email,
      :enforce_profile_edit,
      :phone_number,
      driver_profile_attributes: [
        :id,
        :name,
        :country,
        :verified,
        :address,
        :line2,
        :city,
        :state,
        :postal_code,
        :tagline,
        :bio,
        :company_name,
        :own_tools,
        :valid_driver,
        :service_areas,
        :sales_tax_number,
        :years_of_experience,
        :available,
        :verified,
        :avatar,
        :header_color,
        :profile_header,
        :header_source,
        :driver_type,
        :driver_team_size,
        :pay_unit_time_preference,
        :pay_rate,
        :business_tax_number,
        # rubocop:disable Metrics/LineLength
        job_markets: (I18n.t("enumerize.live_events_staging_and_rental_job_markets").keys + I18n.t("enumerize.system_integration_job_markets").keys).uniq,
        job_functions: (I18n.t("enumerize.system_integration_job_functions").keys + I18n.t("enumerize.live_events_staging_and_rental_job_functions").keys).uniq,
        # rubocop:enable Metrics/LineLength
        technical_skill_tags: I18n.t("enumerize.technical_skill_tags").keys,
        manufacturer_tags: I18n.t("enumerize.manufacturer_tags").keys,
      ],
      certifications_attributes: %i[id certificate cert_type name _destroy],
      driver_affiliations_attributes: %i[id name image _destroy],
      driver_insurances_attributes: %i[id name description image _destroy],
      driver_clearances_attributes: %i[id description image _destroy],
      driver_portfolios_attributes: %i[id name image _destroy],
    )
  end
  # rubocop:enable Metrics/MethodLength

end
