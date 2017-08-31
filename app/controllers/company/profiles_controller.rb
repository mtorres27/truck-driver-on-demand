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
  end

  def update
  end

end
