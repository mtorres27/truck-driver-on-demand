class Admin::FreelancersController < Admin::BaseController
  include LoginAs

  before_action :set_freelancer, only: [:show, :edit, :update, :destroy, :enable, :disable, :login_as]

  def index
    @keywords = params.dig(:search, :keywords).presence

    @freelancers = Freelancer.order(:name)
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
        csv << ['Name', 'Email', 'State/Province', 'Country', 'Date Created', 'Disabled?']
        @freelancers.each do |f|
          csv << [f.name, f.email, f.state, f.country.try(:upcase), f.created_at, f.disabled]
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
