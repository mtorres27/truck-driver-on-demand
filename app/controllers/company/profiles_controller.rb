class Company::ProfilesController < Company::BaseController

  def show
    if params[:id]
      @company = Company.find(params[:id])
    else
      @company = current_company
    end

    # @company.profile_views += 1
    # @company.save
  end

  def edit
    @company = current_company
  end

  def update
    @company = current_company
    if @company.update(company_params)
      redirect_to company_profile_path(@company), notice: "Company profile updated."
    else
      render :edit
    end
  end

  def company_params
    # params.fetch(:freelancer, {})
    params.require(:company).permit(
      :name,
      :contact_name,
      :email,
      :country,
      :area,
      :address,
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
      skills: [
        :flat_panel_displays,
        :video_walls,
        :structured_cabling,
        :rack_work,
        :cable_pull,
        :cable_termination,
        :projectors,
        :troubleshooting,
        :service_and_repair,
        :av_programming,
        :interactive_displays,
        :audio,
        :video_conferencing,
        :video_processors,
        :stagehand,
        :lighting,
        :camera,
        :general_labor,
        :installation,
        :rental
      ],
      keywords: [
        :corporate,
        :government,
        :broadcast,
        :retail,
        :house_of_worship,
        :higher_education,
        :k12_education,
        :residential,
        :commercial_av,
        :live_events_and_staging,
        :rental,
        :hospitality
      ],
    )
  end

end
