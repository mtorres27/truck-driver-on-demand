class Admin::FreelancersController < Admin::BaseController
  include LoginAs

  before_action :set_freelancer, only: [:show, :edit, :update, :destroy, :enable, :disable, :verify, :unverify, :login_as]
  before_action :authorize_freelancer, only: [:show, :edit, :update, :destroy, :enable, :disable, :login_as]

  def index
    authorize current_user
    @keywords = params.dig(:search, :keywords).presence
    @country = params.dig(:search, :country).presence
    @state_province = params.dig(:search, :state_province).presence
    @city = params.dig(:search, :city).presence
    @filter_by_disabled = params.dig(:search, :filter_by_disabled).presence
    @sort = params.dig(:search, :sort).presence

    if @keywords
      @freelancers = Freelancer.admin_search(@keywords)
    else
      @freelancers = Freelancer.all
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
        point = OpenStruct.new(:lat => @geocode[:lat], :lng => @geocode[:lng])
        @distance = 60000
        freelancer_profiles = freelancer_profiles.nearby(@geocode[:lat], @geocode[:lng], @distance).with_distance(point)
      end
    end

    freelancer_profiles = freelancer_profiles.where(country: @country) if @country.present?
    freelancer_profiles = freelancer_profiles.where(state: @state_province) if @state_province.present?

    @freelancers = Freelancer.where(id: freelancer_profiles.pluck(:freelancer_id))
    @freelancer_ids = @freelancers.pluck(:id)

    if @sort.blank?
      @freelancers = Freelancer.includes(:freelancer_profile).where(id: @freelancer_ids).order('freelancer_profiles.created_at DESC')
    else
      if ['first_name', 'email'].include?(@sort)
        @freelancers = Freelancer.where(id: @freelancer_ids).order(@sort)
      else
        @freelancers = Freelancer.includes(:freelancer_profile).where(id: @freelancer_ids).order("freelancer_profiles.#{@sort}")
      end
    end

    if @filter_by_disabled.present? && @filter_by_disabled != 'nil'
      @freelancers = @freelancers.joins(:freelancer_profile).where(freelancer_profiles: { disabled: @filter_by_disabled })
    end

    @freelancers = @freelancers.page(params[:page]).per(10)
  end

  def show
  end

  def edit
  end

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
    redirect_to admin_freelancers_path, notice: "Freelancer verified."
  end

  def unverify
    @freelancer.freelancer_profile.update_column(:verified, false)
    redirect_to admin_freelancers_path, notice: "Freelancer unverified."
  end

  def download_csv
    authorize current_user
    @freelancer_profiles = FreelancerProfile.order('created_at DESC')
    create_csv
    send_data @csv_file, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => 'attachment; filename=freelancers.csv'
  end

  private

  def authorize_freelancer
    authorize @freelancer
  end

  def create_csv
    @csv_file = CSV.generate({}) do |csv|
      csv << @freelancer_profiles.first.freelancer.attributes.keys + @freelancer_profiles.first.attributes.keys unless @freelancer_profiles.first.nil?
      @freelancer_profiles.each do |f|
        csv << f.freelancer.attributes.values + f.attributes.values
      end
    end
  end

  def set_freelancer
    @freelancer = Freelancer.find(params[:id])
  end

  def freelancer_params
    # params.fetch(:freelancer, {})
    params.require(:freelancer).permit(
        :id,
        :first_name,
        :last_name,
        :email,
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
            :phone_number,
            :freelancer_team_size,
            :pay_unit_time_preference,
            :pay_per_unit_time,
            :business_tax_number,
            job_markets: (I18n.t("enumerize.live_events_staging_and_rental_job_markets").keys + I18n.t("enumerize.system_integration_job_markets").keys).uniq,
            job_functions: (I18n.t("enumerize.system_integration_job_functions").keys + I18n.t("enumerize.live_events_staging_and_rental_job_functions").keys).uniq,
            technical_skill_tags:  I18n.t("enumerize.technical_skill_tags").keys,
            manufacturer_tags:  I18n.t("enumerize.manufacturer_tags").keys
        ],
        certifications_attributes: [:id, :certificate, :cert_type, :name, :_destroy],
        freelancer_affiliations_attributes: [:id, :name, :image, :_destroy],
        freelancer_insurances_attributes: [:id, :name, :description, :image, :_destroy],
        freelancer_clearances_attributes: [:id, :description, :image, :_destroy],
        freelancer_portfolios_attributes: [:id, :name, :image, :_destroy],
    )
  end
end
