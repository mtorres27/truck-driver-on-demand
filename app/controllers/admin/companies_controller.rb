class Admin::CompaniesController < Admin::BaseController
  before_action :set_company, only: [:show, :edit, :update, :destroy, :enable, :disable, :login_as]

  def index
    @companies = Company.order(:name).page params[:page]

    # TODO - search
    # search = params[:search]
    #
    # @companies = apply_search(
    #   Company.order(:disabled, :name),
    #   search ? search[:q] : nil
    # ).page(params[:page] || 1).per(20)
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

  def login_as
    session[:company_token] = @company.token
    redirect_to company_root_path, notice: "You have been logged in as #{@company.name}"
  end


  private

    def set_company
      @company = Company.find(params[:id])
    end

    def company_params
      # params.fetch(:company, {:name, :email})
      params.require(:company).permit(:name, :email, :logo)
    end
end
