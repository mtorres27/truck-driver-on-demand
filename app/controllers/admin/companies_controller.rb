# frozen_string_literal: true

class Admin::CompaniesController < Admin::BaseController

  include LoginAs

  before_action :set_company, only: %i[show edit update destroy enable disable login_as messaging]
  def index
    authorize current_user
    @keywords = params.dig(:search, :keywords).presence
    @filter_by_disabled = params.dig(:search, :filter_by_disabled).presence
    @sort = params.dig(:search, :sort).presence

    @company_ids = if @keywords
                     Company.name_or_email_search(@keywords).pluck(:id)
                   else
                     Company.pluck(:id)
                   end

    @companies = if @sort.blank?
                   Company.where(id: @company_ids).order("created_at DESC")
                 elsif ["name", "state", "country", "created_at", "created_at DESC"].include?(@sort)
                   Company.where(id: @company_ids).order(@sort)
                 else
                   Company.includes(:company_user).where(id: @company_ids).order("users.#{@sort}")
                 end

    if @filter_by_disabled.present? && @filter_by_disabled != "nil"
      @companies = @companies.where(disabled: @filter_by_disabled)
    end

    @companies = @companies.page(params[:page]).per(10)
  end

  def jobs
    @company = Company.find(params[:company_id])
    authorize @company
    @jobs = @company.jobs
    @jobs = @jobs.page(params[:page])
  end

  def messaging
    @drivers = @company.drivers_for_messaging
  end

  def show
    authorize @company
  end

  def edit
    authorize @company
  end

  def update
    authorize @company
    @company.attributes = company_params
    if @company.save(validate: false)
      redirect_to admin_company_path(@company), notice: "Company updated."
    else
      render :edit
    end
  end

  def destroy
    authorize @company
    @company.destroy
    redirect_to admin_companies_path, notice: "Company removed."
  end

  def enable
    authorize @company
    @company.enable!
    redirect_to admin_companies_path, notice: "Company enabled."
  end

  def disable
    authorize @company
    @company.disable!
    redirect_to admin_companies_path, notice: "Company disabled."
  end

  def download_csv
    @companies = Company.order("created_at DESC")
    authorize current_user
    create_csv
    # rubocop:disable Metrics/LineLength
    send_data @csv_file, type: "text/csv; charset=iso-8859-1; header=present", disposition: "attachment; filename=companies.csv"
    # rubocop:enable Metrics/LineLength
  end

  private

  def create_csv
    @csv_file = CSV.generate({}) do |csv|
      csv << @companies.first.owner.attributes.keys + @companies.first.attributes.keys unless @companies.first.nil?
      @companies.each do |c|
        csv << c.owner.attributes.values + c.attributes.values
      end
    end
  end

  def set_company
    @company = Company.find(params[:id])
  end

  # rubocop:disable Metrics/MethodLength
  def company_params
    # params.fetch(:company, {:name, :email})
    params.require(:company).permit(
      :id,
      :name,
      :avatar,
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
      # rubocop:disable Metrics/LineLength
      job_markets: (I18n.t("enumerize.live_events_staging_and_rental_job_markets").keys + I18n.t("enumerize.system_integration_job_markets").keys).uniq,
      # rubocop:enable Metrics/LineLength
      technical_skill_tags: I18n.t("enumerize.technical_skill_tags").keys,
      manufacturer_tags: I18n.t("enumerize.manufacturer_tags").keys,
      company_installs_attributes: %i[id year installs _destroy],
      featured_projects_attributes: %i[id file name _destroy],
    )
  end
  # rubocop:enable Metrics/MethodLength

end
