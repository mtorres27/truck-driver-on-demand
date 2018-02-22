class Freelancer::ProfilesController < Freelancer::BaseController
  def show
    if params[:id]
      @freelancer = Freelancer.find(params[:id])
    else
      @freelancer = current_freelancer
    end

    # @freelancer.profile_views += 1
    # @freelancer.save
  end

  def edit
    @freelancer = current_freelancer
  end

  def update
    @freelancer = current_freelancer

    if @freelancer.update(freelancer_params)
      redirect_to freelancer_profile_path(@freelancer), notice: "Freelancer profile updated."
    else
      flash[:error] = 'There are errors with the form, please review and resubmit.'
      render :edit
    end
  end

  private

  def freelancer_params
    params.require(:freelancer).permit(
      :name,
      :email,
      :country,
      :verified,
      :address,
      :line2,
      :city,
      :state,
      :postal_code,
      :tagline,
      :bio,
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
      :enforce_profile_edit,
      :freelancer_team_size,
      :pay_unit_time_preference,
      :pay_per_unit_time,
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
      certifications_attributes: [:id, :certificate, :name, :_destroy],
    )
  end
end