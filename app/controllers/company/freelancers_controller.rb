class Company::FreelancersController < Company::BaseController
  include FreelancerHelper

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

  private

  def unsubscribed_redirect?
    false
  end

end
