class Company::FreelancersController < Company::BaseController
  include FreelancerHelper

  def index
    authorize current_company
    @job_type = params.dig(:search, :job_type).presence
    @job_function = params.dig(:search, :job_function).presence
    @address = params.dig(:search, :address).presence
    @state_province = params.dig(:search, :state_province).presence
    @country = params.dig(:search, :country).presence
    @avatar_only = params.dig(:search, :avatar_only) == "1"

    if params.has_key?(:search) && ( !@job_type || !@job_function || !@address || !@country || (['ca', 'us'].include?(@country) && ! @state_province) )
      flash[:error] = "You'll need complete all the fields to search for freelancers"
      @freelancer_profiles = FreelancerProfile.none.page(params[:page]).per(10)
      return
    end

    @distance = params.dig(:search, :distance).presence

    if @avatar_only
      @freelancer_profiles = FreelancerProfile.where(disabled: false).where.not(avatar_data: nil)
    else
      @freelancer_profiles = FreelancerProfile.where(disabled: false)
    end

    @freelancer_profiles = @freelancer_profiles.where(country: @country)
    @freelancer_profiles = @freelancer_profiles.where("job_types like ?", "%#{@job_type}%")
    @freelancer_profiles = @freelancer_profiles.where("job_functions like ?", "%#{@job_function}%")

    @address_for_geocode = @address.capitalize
    @address_for_geocode += ", #{CS.states(@country.to_sym)[@state_province.to_sym]}" if @state_province.present?
    @address_for_geocode += ", #{CS.countries[@country.upcase.to_sym]}" if @country.present?

    # check for cached version of address
    if Rails.cache.read(@address_for_geocode)
      @geocode = Rails.cache.read(@address_for_geocode)
    else
      # save cached version of address
      @geocode = do_geocode(@address_for_geocode)
      Rails.cache.write(@address_for_geocode, @geocode)
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
    @freelancer_profiles = @freelancer_profiles.page(params[:page]).per(10)
  end

  def hired
    authorize current_company, :index?
    @locations = current_company.freelancers.uniq.pluck(:city)
    @freelancers = current_company.freelancers.distinct

    if params[:location].present?
      freelancer_profiles = FreelancerProfile.where(freelancer_id: @freelancers.map(&:id))
      freelancer_profiles = freelancer_profiles.where(city: params[:location])
      @freelancers = Freelancer.where(id: freelancer_profiles.map(&:freelancer_id))
    end

    @freelancers = @freelancers.page(params[:page]).per(10)
  end

  def favourites
    authorize current_company, :index?
    @locations = current_company.favourite_freelancers.uniq.pluck(:city)
    @freelancers = current_company.favourite_freelancers

    if params[:location] && params[:location] != ""
      freelancer_profiles = FreelancerProfile.where(freelancer_id: @freelancers.map(&:id))
      freelancer_profiles = freelancer_profiles.where(city: params[:location])
      @freelancers = Freelancer.where(id: freelancer_profiles.map(&:freelancer_id))
    end

    @freelancers = @freelancers.page(params[:page]).per(50)
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
        message = "We were unable to send your invite. Please try again."
      elsif result == 2
        message = "This freelancer has already applied for this job."
      elsif result == 3
        message = "This freelancer has already received an invitation to apply for this job."
      end

      ret = { success: 0, message: message}
    end

    render json: ret
  end


  def show
    hashids = Hashids.new(Rails.application.secrets.hash_ids_salt)
    id = hashids.decode(params[:id])

    if id.count == 0
      render_404
      return
    end

    id = id[0]

    @freelancer = Freelancer.find(id)
    authorize @freelancer

    @jobs = []
    @jobs_master = current_company.jobs.where(state: "published").order(title: :asc).distinct
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

    @favourite = current_company.favourites.where(freelancer_id: id).length > 0 ? true : false
    if params.dig(:toggle_favourite) == "true"
      if @favourite == false
        current_company.favourite_freelancers << @freelancer
        @favourite = true
      else
        current_company.favourites.where({freelancer_id: @freelancer.id}).destroy_all
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

  def add_favourites
    authorize current_company
    id = current_user.id
    if params[:freelancers].nil?
      render json: { status: 'parameter missing' }
      return
    end

    params[:freelancers].each do |id|
      f = Freelancer.where({ id: id.to_i })

      if f.length > 0
        current_user.company.favourite_freelancers << f.first
      end
    end

    render json: { status: 'success', freelancers: params[:freelancers] }
  end

end
