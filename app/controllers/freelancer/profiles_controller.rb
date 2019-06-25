class Freelancer::ProfilesController < Freelancer::BaseController
  def show
    if params[:id]
      @freelancer = Freelancer.find(params[:id])
    else
      @freelancer = current_user
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
          :pay_per_unit_time,
          :business_tax_number,
          job_markets: (I18n.t("enumerize.live_events_staging_and_rental_job_markets").keys + I18n.t("enumerize.system_integration_job_markets").keys).uniq,
          job_functions: (I18n.t("enumerize.system_integration_job_functions").keys + I18n.t("enumerize.live_events_staging_and_rental_job_functions").keys).uniq,
          technical_skill_tags:  I18n.t("enumerize.technical_skill_tags").keys,
          manufacturer_tags:  I18n.t("enumerize.manufacturer_tags").keys
      ],
      certifications_attributes: [:id, :certificate, :cert_type, :name, :_destroy],
      freelancer_affiliations_attributes: [:id, :name, :image, :_destroy],
      freelancer_insurances_attributes: [:id, :name, :description, :image, :_destroy],
      freelancer_clearances_attributes: [:id, :description, :image, :_destroy],
      freelancer_portfolios_attributes: [:id, :name, :image, :_destroy],
    )
  end
end
