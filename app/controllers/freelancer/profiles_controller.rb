# frozen_string_literal: true

class Freelancer::ProfilesController < Freelancer::BaseController

  def show
    @freelancer = if params[:id]
                    Freelancer.find(params[:id])
                  else
                    current_user
                  end
    authorize @freelancer
  end

  def edit
    @freelancer = current_user
    authorize @freelancer
  end

  def update
    @freelancer = current_user
    authorize @freelancer

    if @freelancer.update(freelancer_params)
      redirect_to freelancer_profile_path(@freelancer)
    else
      render :edit
    end
  end

  private

  # rubocop:disable Metrics/MethodLength
  def freelancer_params
    params.require(:freelancer).permit(
      :id,
      :first_name,
      :last_name,
      :email,
      :enforce_profile_edit,
      :phone_number,
      freelancer_profile_attributes: [
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
        :freelancer_type,
        :freelancer_team_size,
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
      freelancer_affiliations_attributes: %i[id name image _destroy],
      freelancer_insurances_attributes: %i[id name description image _destroy],
      freelancer_clearances_attributes: %i[id description image _destroy],
      freelancer_portfolios_attributes: %i[id name image _destroy],
    )
  end
  # rubocop:enable Metrics/MethodLength

end
