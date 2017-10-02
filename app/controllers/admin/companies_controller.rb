class Admin::CompaniesController < Admin::BaseController
  include LoginAs

  before_action :set_company, only: [:show, :edit, :update, :destroy, :enable, :disable, :login_as]

  def index
    @keywords = params.dig(:search, :keywords).presence

    @companies = Company.order(:name)
    if @keywords
      @companies = @companies.search(@keywords)
    end
    @companies = @companies.page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    if @company.update(company_params)
      redirect_to admin_company_path(@company), notice: "Company updated."
    else
      render :edit
    end
  end

  def destroy
    @company.destroy
    redirect_to admin_companies_path, notice: "Company removed."
  end

  def enable
    @company.enable!
    redirect_to admin_companies_path, notice: "Company enabled."
  end

  def disable
    @company.disable!
    redirect_to admin_companies_path, notice: "Company disabled."
  end

  private

    def set_company
      @company = Company.find(params[:id])
    end

    def company_params
      # params.fetch(:company, {:name, :email})
      params.require(:company).permit(
        :name, 
        :email, 
        :avatar,
        :contact_name,
        :country,
        :currency,
        :address,
        :area,
        :description,
        :disabled,
        :contract_preference,
        :keywords,
        :skills,
        :website,
        :phone_number,
        :number_of_offices,
        :number_of_employees,
        :established_in
      )
    end
end
