class Admin::FreelancersController < Admin::BaseController
  include LoginAs

  before_action :set_freelancer, only: [:show, :edit, :update, :destroy, :enable, :disable, :login_as]

  def index
    @keywords = params.dig(:search, :keywords).presence

    @freelancers = Freelancer.order('created_at DESC')
    if @keywords
      @freelancers = @freelancers.search(@keywords)
    end
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
    @freelancer.enable!
    redirect_to admin_freelancers_path, notice: "Freelancer enabled."
  end

  def disable
    @freelancer.disable!
    redirect_to admin_freelancers_path, notice: "Freelancer disabled."
  end

  def download_csv
    @freelancers = Freelancer.order('created_at DESC')
    create_csv
    send_data @csv_file, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => 'attachment; filename=freelancers.csv'
  end

  private

    def create_csv
      @csv_file = CSV.generate({}) do |csv|
        csv << @freelancers.first.attributes.keys unless @freelancers.first.nil?
        @freelancers.each do |f|
          csv << f.attributes.values
        end
      end
    end

    def set_freelancer
      @freelancer = Freelancer.find(params[:id])
    end

    def freelancer_params
      # params.fetch(:freelancer, {})
      params.require(:freelancer).permit(
        :name,
        :email,
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
        :verified,
        :service_areas,
        :sales_tax_number,
        :avatar,
        :pay_unit_time_preference,
        :disabled,
        :verified,
        job_types: I18n.t("enumerize.freelancer_job_types").keys,
        job_markets: (I18n.t("enumerize.freelancer_live_events_staging_and_rental_job_markets").keys + I18n.t("enumerize.freelancer_system_integration_job_markets").keys).uniq,
        job_functions: (I18n.t("enumerize.freelancer_system_integration_job_functions").keys + I18n.t("enumerize.freelancer_live_events_staging_and_rental_job_functions").keys).uniq,
        technical_skill_tags:  I18n.t("enumerize.freelancer_technical_skill_tags").keys,
        manufacturer_tags:  I18n.t("enumerize.freelancer_manufacturer_tags").keys
      )

    end

end
