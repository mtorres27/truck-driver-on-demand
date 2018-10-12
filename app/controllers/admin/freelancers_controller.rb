class Admin::FreelancersController < Admin::BaseController
  include LoginAs

  before_action :set_freelancer, only: [:show, :edit, :update, :destroy, :enable, :disable, :login_as]
  before_action :authorize_freelancer, only: [:show, :edit, :update, :destroy, :enable, :disable, :login_as]

  def index
    authorize current_user
    @keywords = params.dig(:search, :keywords).presence
    @filter_by_disabled = params.dig(:search, :filter_by_disabled).presence
    @sort = params.dig(:search, :sort).presence

    if @keywords
      @freelancer_ids = Freelancer.admin_search(@keywords).pluck(:id)
    else
      @freelancer_ids = Freelancer.pluck(:id)
    end

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
      :email,
      freelancer_profile_attributes: [
          :id,
          :name,
          :address,
          :line2,
          :city,
          :state,
          :postal_code,
          :country,
          :tagline,
          :bio,
          :years_of_experience,
          :available,
          :service_areas,
          :sales_tax_number,
          :avatar,
          :pay_unit_time_preference,
          :disabled,
          :verified,
          :special_avj_fees,
          :header_color,
          :profile_header,
          :header_source,
          :business_tax_number,
          job_types: I18n.t("enumerize.job_types").keys,
          job_markets: (I18n.t("enumerize.live_events_staging_and_rental_job_markets").keys + I18n.t("enumerize.system_integration_job_markets").keys).uniq,
          job_functions: (I18n.t("enumerize.system_integration_job_functions").keys + I18n.t("enumerize.live_events_staging_and_rental_job_functions").keys).uniq,
          technical_skill_tags:  I18n.t("enumerize.technical_skill_tags").keys,
          manufacturer_tags:  I18n.t("enumerize.manufacturer_tags").keys
      ],
      certifications_attributes: [:id, :certificate, :cert_type, :name, :_destroy],
      freelancer_affiliations_attributes: [:id, :name, :image, :_destroy],
      freelancer_insurances_attributes: [:id, :name, :description, :image, :_destroy],
      freelancer_clearances_attributes: [:id, :description, :image, :_destroy],
      freelancer_portfolios_attributes: [:id, :name, :image, :_destroy]
    )
  end
end
