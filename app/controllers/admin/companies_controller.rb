class Admin::CompaniesController < Admin::BaseController
  include LoginAs

  before_action :set_company, only: [:show, :edit, :update, :destroy, :enable, :disable, :login_as]

  def index
    @keywords = params.dig(:search, :keywords).presence

    @companies = Company.order('created_at DESC')
    if @keywords
      @companies = @companies.name_or_email_search(@keywords)
    end
  end

  def jobs
    @company = Company.find(params[:company_id])
    @jobs = @company.jobs
    @jobs = @jobs.page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    @company.attributes = company_params
    if @company.save(validate: false)
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

  def download_csv
    @companies = Company.order('created_at DESC')
    create_csv
    send_data @csv_file, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => 'attachment; filename=companies.csv'
  end

  private

    def create_csv
      @csv_file = CSV.generate({}) do |csv|
        csv << @companies.first.attributes.keys unless @companies.first.nil?
        @companies.each do |c|
          csv << c.attributes.values
        end
      end
    end

    def set_company
      @company = Company.find(params[:id])
    end

    def company_params
      # params.fetch(:company, {:name, :email})
      params.require(:company).permit(
        :id,
        :email,
        company_data_attributes: [
            :name,
            :avatar,
            :contact_name,
            :country,
            :sales_tax_number,
            :line2,
            :state,
            :postal_code,
            :city,
            :currency,
            :address,
            :area,
            :description,
            :disabled,
            :contract_preference,
            :website,
            :waived_jobs,
            :phone_number,
            :number_of_offices,
            :number_of_employees,
            :established_in,
            :header_color,
            :profile_header,
            :header_source,
            job_types: I18n.t("enumerize.job_types").keys,
            job_markets: (I18n.t("enumerize.live_events_staging_and_rental_job_markets").keys + I18n.t("enumerize.system_integration_job_markets").keys).uniq,
            technical_skill_tags:  I18n.t("enumerize.technical_skill_tags").keys,
            manufacturer_tags:  I18n.t("enumerize.manufacturer_tags").keys
        ],
        company_installs_attributes: [:id, :year, :installs, :_destroy],
        featured_projects_attributes: [:id, :file, :name, :_destroy]
      )
    end
end
