# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class Admin::FreelancersController < Admin::BaseController

  include LoginAs

  before_action :set_freelancer, only: %i[show edit update destroy enable disable verify unverify login_as messaging]
  before_action :authorize_freelancer, only: %i[show edit update destroy enable disable login_as]

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

    @freelancers = if @keywords
                     Freelancer.admin_search(@keywords)
                   else
                     Freelancer.all
                   end

    freelancer_profiles = FreelancerProfile.where(freelancer_id: @freelancers.pluck(:id))

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
        freelancer_profiles = freelancer_profiles.nearby(@geocode[:lat], @geocode[:lng], @distance).with_distance(point)
      end
    end

    freelancer_profiles = freelancer_profiles.where(country: @country) if @country.present?
    freelancer_profiles = freelancer_profiles.where(state: @state_province) if @state_province.present?

    @freelancers = Freelancer.where(id: freelancer_profiles.pluck(:freelancer_id))
    @freelancer_ids = @freelancers.pluck(:id)

    @freelancers = if @sort.blank?
                     Freelancer.includes(:freelancer_profile)
                               .where(id: @freelancer_ids).order("freelancer_profiles.created_at DESC")
                   elsif %w[first_name email].include?(@sort)
                     Freelancer.where(id: @freelancer_ids).order(@sort)
                   else
                     Freelancer.includes(:freelancer_profile)
                               .where(id: @freelancer_ids).order("freelancer_profiles.#{@sort}")
                   end

    if @filter_by_disabled.present? && @filter_by_disabled != "nil"
      @freelancers = @freelancers.joins(:freelancer_profile)
                                 .where(freelancer_profiles: { disabled: @filter_by_disabled })
    end

    @freelancers = @freelancers.page(params[:page]).per(10)
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  def show; end

  def edit; end

  def update
    @freelancer.attributes = freelancer_params
    if @freelancer.save(validate: false)
      redirect_to admin_freelancer_path(@freelancer), notice: "Freelancer updated."
    else
      render :edit
    end
  end

  def destroy
    @freelancer.destroy
    redirect_to admin_freelancers_path, notice: "Freelancer removed."
  end

  def enable
    @freelancer.freelancer_profile.enable!
    redirect_to admin_freelancers_path, notice: "Freelancer enabled."
  end

  def disable
    @freelancer.freelancer_profile.disable!
    redirect_to admin_freelancers_path, notice: "Freelancer disabled."
  end

  def verify
    @freelancer.freelancer_profile.update_column(:verified, true)
    redirect_to admin_freelancer_path(@freelancer), notice: "Freelancer verified."
  end

  def unverify
    @freelancer.freelancer_profile.update_column(:verified, false)
    redirect_to admin_freelancer_path(@freelancer), notice: "Freelancer unverified."
  end

  def download_csv
    authorize current_user
    @freelancer_profiles = FreelancerProfile.order("created_at DESC")
    create_csv
    # rubocop:disable Metrics/LineLength
    send_data @csv_file, type: "text/csv; charset=iso-8859-1; header=present", disposition: "attachment; filename=freelancers.csv"
    # rubocop:enable Metrics/LineLength
  end

  def messaging
    @companies = @freelancer.companies_for_messaging
  end

  private

  def authorize_freelancer
    authorize @freelancer
  end

  def create_csv
    @csv_file = CSV.generate({}) do |csv|
      unless @freelancer_profiles.first.nil?
        # rubocop:disable Metrics/LineLength
        csv << @freelancer_profiles.first.freelancer.attributes.keys + @freelancer_profiles.first.attributes.keys + ["job_types"]
        # rubocop:enable Metrics/LineLength
      end
      @freelancer_profiles.each do |f|
        csv << f.freelancer.attributes.values + f.attributes.values + [f.job_types]
      end
    end
  end

  def set_freelancer
    @freelancer = Freelancer.find(params[:id])
  end

  # rubocop:disable Metrics/MethodLength
  def freelancer_params
    # params.fetch(:freelancer, {})
    params.require(:freelancer).permit(
      :id,
      :first_name,
      :last_name,
      :email,
      :phone_number,
      :enforce_profile_edit,
      freelancer_profile_attributes: [
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
        :freelancer_type,
        :freelancer_team_size,
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
      freelancer_affiliations_attributes: %i[id name image _destroy],
      freelancer_insurances_attributes: %i[id name description image _destroy],
      freelancer_clearances_attributes: %i[id description image _destroy],
      freelancer_portfolios_attributes: %i[id name image _destroy],
    )
  end
  # rubocop:enable Metrics/MethodLength

end
# rubocop:enable Metrics/ClassLength
