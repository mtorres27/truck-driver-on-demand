class Freelancer::ProfilesController < Freelancer::BaseController
  def show
    if params[:id]
      @freelancer = Freelancer.find(params[:id])
    else
      @freelancer = current_freelancer
    end

    @freelancer.profile_views += 1
    @freelancer.save
  end

  def edit
    @freelancer = current_freelancer
  end

  def update
    @freelancer = current_freelancer
    if @freelancer.update(freelancer_params)
      redirect_to freelancer_profile_path(@freelancer), notice: "Freelancer profile updated."
    else
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
      :area,
      :tagline,
      :bio,
      :keywords,
      :skills,
      :years_of_experience,
      :available,
      :verified,
      :avatar,
      :header_color,
      :profile_header,
      :freelancer_type,
      :freelancer_team_size,
      :pay_unit_time_preference,
      certifications_attributes: [:id, :certificate, :name, :_destroy],
    )
  end
end