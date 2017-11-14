class Company::FreelancersController < Company::BaseController
  include FreelancerHelper

  def index
    @keywords = params.dig(:search, :keywords).presence
    @address = params.dig(:search, :address).presence

    @sort = params.dig(:search, :sort).presence
    @distance = params.dig(:search, :distance).presence

    if @sort == "ASC"
      sort = :asc
    elsif @sort == "DESC"
      sort = :desc
    elsif @sort == "RELEVANCE"
      sort = nil
    end

    if sort != nil
      @freelancers = Freelancer.order(name: sort)
    else
      @freelancers = Freelancer.all
    end

    if @address
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
          @distance = 60000
        end
        @freelancers = @freelancers.nearby(@geocode[:lat], @geocode[:lng], @distance).with_distance(point).order("distance")
      else
        @freelancers = Freelancer.none
      end
    end

    if @keywords
      @freelancers = @freelancers.search(@keywords)
    end

    @freelancers = @freelancers.page(params[:page]).per(50)
  end

  def hired
    @locations = current_company.freelancers.uniq.pluck(:area)
    @freelancers = current_company.freelancers.distinct

    if params[:location] && params[:location] != ""
      @freelancers = @freelancers.where({ area: params[:location] })
    end
    
    @freelancers = @freelancers.page(params[:page]).
      per(50)
  end

  def favourites
    @locations = current_company.favourite_freelancers.uniq.pluck(:area)
    @freelancers = current_company.favourite_freelancers

    if params[:location] && params[:location] != ""
      @freelancers = @freelancers.where({ area: params[:location] })
    end

    @freelancers = @freelancers.page(params[:page]).
      per(50)
  end

  def invite_to_quote
    p '!!!!!!!!!'
    p params
    if params[:job_to_invite].nil? or params[:job_to_invite] == ""
      result = 0
    else
      @job_id = params[:job_to_invite].to_i
      p "JOB ID"
      p @job_id
      if Job.find(@job_id).nil? or Job.find(@job_id).state != "published"
        result = 0
      else
        @job = Job.find(@job_id)
        @freelancer = Freelancer.find(params[:id])

        if @job.applicants.where({ freelancer_id: params[:id] }).count > 0
          result = 2
        elsif @job.job_invites.where({ freelancer_id: params[:id]}).count > 0
          result = 3
        else
          # freelancer is clear to be invited
          JobInviteMailer.invite_to_quote(@freelancer, @job).deliver
          @invite = JobInvite.new
          @invite.freelancer_id = @freelancer.id
          @invite.job_id = @job.id

          @invite.save
          result = 1
        end


      end
    end

    redirect_to "/company/freelancers/#{params[:id]}?invite_to_quote=true&result=#{result}"
  end


  def show
    @freelancer = Freelancer.find(params[:id])

    @jobs = current_company.jobs.where({ state: "published" }).order('title ASC')

    # analytic
    if params.dig(:toggle_favourite) != "true" and params.dig(:invite_to_quote) != "true"
      @freelancer.profile_views += 1
    end
    @freelancer.save

    @favourite = current_company.favourites.where({freelancer_id: params[:id]}).length > 0 ? true : false
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
    id = current_company.id
    if params[:freelancers].nil?
      render json: { status: 'parameter missing' }
      return
    end

    params[:freelancers].each do |id|
      f = Freelancer.where({ id: id.to_i })

      if f.length > 0
        current_company.favourite_freelancers << f.first
      end
    end
          
    render json: { status: 'success', freelancers: params[:freelancers] }

  end

end
