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

  # def create
  #   @company = Company.new(company_params)
  #
  #   respond_to do |format|
  #     if @company.save
  #       format.html { redirect_to @company, notice: "Company created." }
  #       format.json { render :show, status: :created, location: @company }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @company.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to admin_company_path(@company), notice: "Company updated." }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @company.destroy

    respond_to do |format|
      format.html { redirect_to admin_companies_path, notice: "Company removed." }
      format.json { head :no_content }
    end
  end

  def enable
    @company.enable!

    respond_to do |format|
      format.html { redirect_to admin_companies_path, notice: "Company enabled." }
      format.json { head :no_content }
    end
  end

  def disable
    @company.disable!

    respond_to do |format|
      format.html { redirect_to admin_companies_path, notice: "Company disabled." }
      format.json { head :no_content }
    end
  end

  def login_as
    session[:company_id] = @company.id
    redirect_to company_root_path, notice: "You have been logged in as #{@company.name}"
  end


  private

    def set_company
      @company = Company.find(params[:id])
    end

    def company_params
      params.fetch(:company, {})
    end
end
