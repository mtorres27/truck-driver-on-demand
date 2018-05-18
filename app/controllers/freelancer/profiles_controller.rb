class Freelancer::ProfilesController < Freelancer::BaseController
  def show
    if params[:id]
      @freelancer = Freelancer.find(params[:id])
    else
      @freelancer = current_freelancer
    end

    # @freelancer.profile_views += 1
    # @freelancer.save
  end

  def edit
    @freelancer = current_freelancer
  end

  def update
    @freelancer = current_freelancer

    if @freelancer.update(freelancer_params)
      redirect_to freelancer_profile_path(@freelancer), notice: "Freelancer profile updated."
    else
      flash[:error] = 'There are errors with the form, please review and resubmit.'
      render :edit
    end
  end

  private

  def freelancer_params
    params.require(:freelancer).permit(
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
      :phone_number,
      :enforce_profile_edit,
      :freelancer_team_size,
      :pay_unit_time_preference,
      :pay_per_unit_time,
      job_types: I18n.t("enumerize.job_types").keys,
      job_markets: (I18n.t("enumerize.live_events_staging_and_rental_job_markets").keys + I18n.t("enumerize.system_integration_job_markets").keys).uniq,
      job_functions: (I18n.t("enumerize.system_integration_job_functions").keys + I18n.t("enumerize.live_events_staging_and_rental_job_functions").keys).uniq,
      technical_skill_tags:  I18n.t("enumerize.technical_skill_tags").keys,
      manufacturer_tags:  I18n.t("enumerize.manufacturer_tags").keys,
      certifications_attributes: [:id, :certificate, :cert_type, :name, :_destroy],
      freelancer_affiliations_attributes: [:id, :name, :image, :_destroy],
      freelancer_insurances_attributes: [:id, :name, :description, :image, :_destroy],
      freelancer_clearances_attributes: [:id, :description, :image, :_destroy],
      freelancer_portfolios_attributes: [:id, :name, :image, :_destroy],
      user_attributes: [:id, :email]
    )
  end
end