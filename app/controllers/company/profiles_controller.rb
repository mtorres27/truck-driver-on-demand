class Company::ProfilesController < Company::BaseController

  def show
    authorize current_company
  end

  def edit
    authorize current_company
  end

  def update
    authorize current_company

    if current_company.update(company_params)
      redirect_to company_profile_path, notice: "Company profile updated."
    else
      flash[:error] = 'There are errors with the form, please review and resubmit.'
      render :edit
    end
  end

  private

  def unsubscribed_redirect?
    false
  end

  def company_params
    params.require(:company).permit(
      :id,
      :enforce_profile_edit,
      :name,
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
      job_types: I18n.t("enumerize.job_types").keys,
      job_markets: (I18n.t("enumerize.live_events_staging_and_rental_job_markets").keys + I18n.t("enumerize.system_integration_job_markets").keys).uniq,
      technical_skill_tags:  I18n.t("enumerize.technical_skill_tags").keys,
      manufacturer_tags:  I18n.t("enumerize.manufacturer_tags").keys,
      company_installs_attributes: [:id, :year, :installs, :_destroy],
      featured_projects_attributes: [:id, :file, :name, :_destroy],
      company_user_attributes: [:id, :first_name, :last_name, :email],
    )
  end
end
