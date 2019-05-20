class Company::FreelancersController < Company::BaseController
  include FreelancerHelper

  def index
    @keywords = params.dig(:search, :keywords).presence
    @address = params.dig(:search, :address).presence
    @country = params.dig(:search, :country).presence
    @job_type = params.dig(:search, :job_type).presence
    @job_function = params.dig(:search, :job_function).presence

    if params.has_key?(:search) && (!@address || !@country)
      flash[:error] = "You'll need to provide a location and country to search for freelancers"
      @freelancer_profiles = FreelancerProfile.none.page(params[:page]).per(10)
      return
    end

    @distance = params.dig(:search, :distance).presence

    if @keywords.blank?
      @freelancer_profiles = FreelancerProfile.where(disabled: false, country: @country)
    else
      @freelancer_profiles = FreelancerProfile.search(@keywords).where(disabled: false, country: @country)
    end

    @freelancer_profiles = @freelancer_profiles.where("job_types like ?", "%#{@job_type}%") if @job_type.present?
    @freelancer_profiles = @freelancer_profiles.where("job_functions like ?", "%#{@job_function}%") if @job_function.present?

    @address_for_geocode = @address + ", " + @country.upcase

    # check for cached version of address
    if Rails.cache.read(@address)
      @geocode = Rails.cache.read(@address)
    else
      # save cached version of address
      @geocode = do_geocode(@address)
      Rails.cache.write(@address, @geocode)
    end

    if @geocode
      point = OpenStruct.new(:lat => @geocode[:lat], :lng => @geocode[:lng])
      if @distance.nil?
        @distance_int = 60000
      else
        @distance_int = @distance.to_i
      end
      @freelancer_profiles = @freelancer_profiles.nearby(@geocode[:lat], @geocode[:lng], @distance_int).with_distance(point).order("verified DESC, profile_score DESC, distance")
    else
      @freelancer_profiles = FreelancerProfile.none
    end

    @freelancer_profiles_with_distances = @freelancer_profiles
    @featured_freelancers = @freelancer_profiles.where(verified: true)
    @freelancer_profiles = @freelancer_profiles.page(params[:page]).per(10)
  end

  def hired
    authorize current_company, :index?
    @freelancers = current_company.hired_freelancers.distinct
    @freelancers = @freelancers.page(params[:page]).per(10)
  end

  def saved
    authorize current_company, :index?
    @freelancers = current_company.freelancers
    @freelancers = @freelancers.page(params[:page]).per(10)
  end

  def invite_to_quote
    if params[:job_to_invite].nil? or params[:job_to_invite] == ""
      result = 0
    else
      @job_id = params[:job_to_invite].to_i
      if Job.find(@job_id).nil? or Job.find(@job_id).state != "published"
        result = 0
      else
        @job = Job.find(@job_id)
        authorize @job

        @freelancer = Freelancer.find(params[:id])

        if @job.applicants.where({ freelancer_id: params[:id] }).count > 0
          result = 2
        elsif @job.job_invites.where({ freelancer_id: params[:id]}).count > 0
          result = 3
        else
          # freelancer is clear to be invited
          Notification.create(title: @job.title, body: "You've been invited to apply", authorable: @job.company, receivable: @freelancer, url: freelancer_job_url(@job))
          JobInviteMailer.invite_to_quote(@freelancer, @job).deliver_later
          @invite = JobInvite.new
          @invite.freelancer_id = @freelancer.id
          @invite.job_id = @job.id

          @invite.save
          result = 1
        end
      end
    end

    if result == 1
      ret = { success: 1, message: "Invite Sent!"}
    else
      if result == 0
        message = "Unable to send invite. Please try again."
      elsif result == 2
        message = "Already applied."
      elsif result == 3
        message = "Already invited."
      end

      ret = { success: 0, message: message}
    end

    render json: ret
  end


  def show
    hashids = Hashids.new(Rails.application.secrets.hash_ids_salt, 8)
    id = hashids.decode(params[:id])

    if id.count == 0
      render_404
      return
    end

    id = id[0]

    @freelancer = Freelancer.find(id)
    authorize @freelancer

    @jobs = []
    @jobs_master = current_company.jobs.where(state: "published").order(title: :asc)
    @jobs_master.each do |job|
      @found = false
      job.applicants.each do |applicant|
        p applicant.freelancer_id
        p @freelancer.id

        if applicant.freelancer_id == @freelancer.id
          p "FOUND"
          @found = true
        end
      end
      p "FOUND?"
      p @found
      if @found == false
        @jobs << job
      end
    end

    # analytic
    if params.dig(:toggle_favourite) != "true" and params.dig(:invite_to_quote) != "true"
      @freelancer.freelancer_profile.profile_views += 1
    end
    @freelancer.freelancer_profile.save

    @favourite = current_company.freelancers.where(id: id).length > 0 ? true : false
    if params.dig(:toggle_favourite) == "true"
      if @favourite == false
        current_company.update_attribute(:saved_freelancers_ids, current_company.saved_freelancers_ids + [@freelancer.id])
        @favourite = true
      else
        current_company.update_attribute(:saved_freelancers_ids, current_company.saved_freelancers_ids - [@freelancer.id])
        @favourite = false
      end
    end

    if params.dig(:invite_to_quote) == "true" and params.dig(:result).to_i == 1
      @invite_sent = true
    elsif params.dig(:invite_to_quote) == "true" and params.dig(:result).to_i == 0
      @invite_error = 1
    elsif params.dig(:invite_to_quote) == "true" and params.dig(:result).to_i == 2
      @invite_error = 2
    elsif params.dig(:invite_to_quote) == "true" and params.dig(:result).to_i == 3
      @invite_error = 3
    end
  end

  def save_freelancer
    authorize current_company
    current_company.update_attribute(:saved_freelancers_ids, current_company.saved_freelancers_ids + [params[:id].to_i])
    flash[:notice] = "Freelancer added to saved for later."
    redirect_back fallback_location: root_path
  end

  def delete_freelancer
    authorize current_company
    current_company.update_attribute(:saved_freelancers_ids, current_company.saved_freelancers_ids - [params[:id].to_i])
    flash[:notice] = "Freelancer removed from saved for later."
    redirect_back fallback_location: root_path
  end
end
