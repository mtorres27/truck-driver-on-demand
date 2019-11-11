# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class Admin::DriversController < Admin::BaseController

  include LoginAs

  before_action :set_driver, only: %i[show edit update destroy enable disable verify unverify login_as messaging]
  before_action :authorize_driver, only: %i[show edit update destroy enable disable login_as]

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def index
    authorize current_user
    @keywords = params.dig(:search, :keywords).presence
    @country = params.dig(:search, :country).presence
    @state_province = params.dig(:search, :state_province).presence
    @city = params.dig(:search, :city).presence
    @filter_by_disabled = params.dig(:search, :filter_by_disabled).presence
    @sort = params.dig(:search, :sort).presence

    @drivers = if @keywords
                     Driver.admin_search(@keywords)
                   else
                     Driver.all
                   end

    driver_profiles = DriverProfile.where(driver_id: @drivers.pluck(:id))

    if @city
      # check for cached version of address
      @address_for_geocode = @city
      @address_for_geocode += ", #{CS.states(@country.to_sym)[@state_province.to_sym]}" if @state_province.present?
      @address_for_geocode += ", #{CS.countries[@country.upcase.to_sym]}" if @country.present?
      if Rails.cache.read(@address_for_geocode)
        @geocode = Rails.cache.read(@address_for_geocode)
      else
        # save cached version of address
        @geocode = do_geocode(@address_for_geocode)
        Rails.cache.write(@address_for_geocode, @geocode)
      end

      if @geocode
        point = OpenStruct.new(lat: @geocode[:lat], lng: @geocode[:lng])
        @distance = 60_000
        driver_profiles = driver_profiles.nearby(@geocode[:lat], @geocode[:lng], @distance).with_distance(point)
      end
    end

    driver_profiles = driver_profiles.where(country: @country) if @country.present?
    driver_profiles = driver_profiles.where(state: @state_province) if @state_province.present?

    @drivers = Driver.where(id: driver_profiles.pluck(:driver_id))
    @driver_ids = @drivers.pluck(:id)

    @drivers = if @sort.blank?
                     Driver.includes(:driver_profile)
                               .where(id: @driver_ids).order("driver_profiles.created_at DESC")
                   elsif %w[first_name email].include?(@sort)
                     Driver.where(id: @driver_ids).order(@sort)
                   else
                     Driver.includes(:driver_profile)
                               .where(id: @driver_ids).order("driver_profiles.#{@sort}")
                   end

    if @filter_by_disabled.present? && @filter_by_disabled != "nil"
      @drivers = @drivers.joins(:driver_profile)
                                 .where(driver_profiles: { disabled: @filter_by_disabled })
    end

    @drivers = @drivers.page(params[:page]).per(10)
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  def show; end

  def edit; end

  def update
    @driver.attributes = driver_params
    if @driver.save(validate: false)
      redirect_to admin_driver_path(@driver), notice: "Driver updated."
    else
      render :edit
    end
  end

  def destroy
    @driver.destroy
    redirect_to admin_drivers_path, notice: "Driver removed."
  end

  def enable
    @driver.driver_profile.enable!
    redirect_to admin_drivers_path, notice: "Driver enabled."
  end

  def disable
    @driver.driver_profile.disable!
    redirect_to admin_drivers_path, notice: "Driver disabled."
  end

  def verify
    @driver.driver_profile.update_column(:verified, true)
    redirect_to admin_driver_path(@driver), notice: "Driver verified."
  end

  def unverify
    @driver.driver_profile.update_column(:verified, false)
    redirect_to admin_driver_path(@driver), notice: "Driver unverified."
  end

  def download_csv
    authorize current_user
    @driver_profiles = DriverProfile.order("created_at DESC")
    create_csv
    # rubocop:disable Metrics/LineLength
    send_data @csv_file, type: "text/csv; charset=iso-8859-1; header=present", disposition: "attachment; filename=drivers.csv"
    # rubocop:enable Metrics/LineLength
  end

  def messaging
    @companies = @driver.companies_for_messaging
  end

  private

  def authorize_driver
    authorize @driver
  end

  def create_csv
    @csv_file = CSV.generate({}) do |csv|
      unless @driver_profiles.first.nil?
        # rubocop:disable Metrics/LineLength
        csv << @driver_profiles.first.driver.attributes.keys + @driver_profiles.first.attributes.keys + ["job_types"]
        # rubocop:enable Metrics/LineLength
      end
      @driver_profiles.each do |f|
        csv << f.driver.attributes.values + f.attributes.values + [f.job_types]
      end
    end
  end

  def set_driver
    @driver = Driver.find(params[:id])
  end

  # rubocop:disable Metrics/MethodLength
  def driver_params
    # params.fetch(:driver, {})
    params.require(:driver).permit(
      :id,
      :first_name,
      :last_name,
      :email,
      :phone_number,
      :enforce_profile_edit,
      driver_profile_attributes: [
        :id,
        :name,
        :country,
        :verified,
        :address,
        :line2,
        :city,
        :state,
        :postal_code,
        :tagline,
        :bio,
        :company_name,
        :own_tools,
        :valid_driver,
        :service_areas,
        :sales_tax_number,
        :years_of_experience,
        :available,
        :verified,
        :avatar,
        :header_color,
        :profile_header,
        :header_source,
        :driver_type,
        :driver_team_size,
        :pay_unit_time_preference,
        :pay_rate,
        :business_tax_number,
        # rubocop:disable Metrics/LineLength
        job_markets: (I18n.t("enumerize.live_events_staging_and_rental_job_markets").keys + I18n.t("enumerize.system_integration_job_markets").keys).uniq,
        job_functions: (I18n.t("enumerize.system_integration_job_functions").keys + I18n.t("enumerize.live_events_staging_and_rental_job_functions").keys).uniq,
        # rubocop:enable Metrics/LineLength
        technical_skill_tags: I18n.t("enumerize.technical_skill_tags").keys,
        manufacturer_tags: I18n.t("enumerize.manufacturer_tags").keys,
      ],
      certifications_attributes: %i[id certificate cert_type name _destroy],
      driver_affiliations_attributes: %i[id name image _destroy],
      driver_insurances_attributes: %i[id name description image _destroy],
      driver_clearances_attributes: %i[id description image _destroy],
      driver_portfolios_attributes: %i[id name image _destroy],
    )
  end
  # rubocop:enable Metrics/MethodLength

end
# rubocop:enable Metrics/ClassLength
