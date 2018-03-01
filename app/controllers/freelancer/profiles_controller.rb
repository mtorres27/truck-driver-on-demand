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
      :email,
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
      job_types: I18n.t("enumerize.freelancer_job_types").keys,
      job_markets: (I18n.t("enumerize.freelancer_live_events_staging_and_rental_job_markets").keys + I18n.t("enumerize.freelancer_system_integration_job_markets").keys).uniq,
      job_functions: (I18n.t("enumerize.freelancer_system_integration_job_functions").keys + I18n.t("enumerize.freelancer_live_events_staging_and_rental_job_functions").keys).uniq,
      technical_skill_tags:  I18n.t("enumerize.freelancer_technical_skill_tags").keys,
      manufacturer_tags:  I18n.t("enumerize.freelancer_manufacturer_tags").keys,
      certifications_attributes: [:id, :certificate, :name, :_destroy]
    )
  end
end