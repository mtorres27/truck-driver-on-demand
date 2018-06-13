class Company::ProfilesController < Company::BaseController

  def show
    if params[:id]
      @company = Company.find(params[:id])
    else
      @company = current_user
    end

    # @company.profile_views += 1
    # @company.save
  end

  def edit
    @company = current_user
    logger.debug current_user.inspect
  end

  def update
    @company = current_user
    if @company.update(company_params)
      redirect_to company_profile_path(@company), notice: "Company profile updated."
    else
      flash[:error] = 'There are errors with the form, please review and resubmit.'
      render :edit
    end
  end

  def company_params
    # params.fetch(:freelancer, {})
    params.require(:company).permit(
      :name,
      :contact_name,
      :country,
      :area,
      :line2,
      :city,
      :state,
      :postal_code,
      :address,
      :sales_tax_number,
      :avatar,
      :header_color,
      :profile_header,
      :description,
      :phone_number,
      :number_of_offices,
      :number_of_employees,
      :contract_preference,
      :established_in,
      :website,
      :header_source,
      :enforce_profile_edit,
      company_installs_attributes: [:id, :year, :installs, :_destroy],
      featured_projects_attributes: [:id, :file, :name, :_destroy],
      job_types: I18n.t("enumerize.job_types").keys,
      job_markets: (I18n.t("enumerize.live_events_staging_and_rental_job_markets").keys + I18n.t("enumerize.system_integration_job_markets").keys).uniq,
      technical_skill_tags:  I18n.t("enumerize.technical_skill_tags").keys,
      manufacturer_tags:  I18n.t("enumerize.manufacturer_tags").keys,
      user_attributes: [:id, :email]
    )
  end

end
