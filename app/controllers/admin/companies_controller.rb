class Admin::CompaniesController < Admin::BaseController
  before_action :load_company, only: [:show, :edit, :update, :destroy, :sign_in_as]

  def index
    @companies = Company.order(:name)

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
    if @company.update_attributes(company_params)
      redirect_to admin_companies_path, notice: "#{@company.name} was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @company.destroy
    redirect_to admin_companies_path, notice: "#{@company.name} was successfully removed."
  end

  # TODO - sign in as
  def sign_in_as
    # authorize @company, :sign_in_as?
    # sign_in(:company, @company)
    # redirect_to members_path, notice: "You have been signed in as #{@company.email}"
  end


  private

  def load_company
    @company = Company.find(params[:id])
  end

end
