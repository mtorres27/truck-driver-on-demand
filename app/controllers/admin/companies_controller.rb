class Admin::CompaniesController < Admin::BaseController
  include LoginAs

  before_action :set_company, only: [:show, :edit, :update, :destroy, :enable, :disable, :login_as]

  def index
    @keywords = params.dig(:search, :keywords).presence

    @companies = Company.order('created_at DESC')
    if @keywords
      @companies = @companies.search(@keywords)
    end
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
        :name,
        :email,
        :avatar,
        :contact_name,
        :country,
        :sales_tax_number,
        :province,
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
        :phone_number,
        :number_of_offices,
        :number_of_employees,
        :established_in,
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
