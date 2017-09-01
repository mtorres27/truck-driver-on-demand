class Company::ProfilesController < Company::BaseController

  def show
    if params[:id]
      @company = Company.find(params[:id])
    else
      @company = current_company
    end

    @company.profile_views += 1
    @company.save
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
      :area,
      :address,
      :avatar,
      :profile_header,
      :description,
      :skills,
      :keywords,
      :phone_number,
      :number_of_offices,
      :number_of_employees,
      :contract_preference,
      :established_in,
      :website,
      company_installs_attributes: [:id, :year, :installs, :_destroy],
      featured_projects_attributes: [:id, :file, :name, :_destroy],
    )
  end

end
