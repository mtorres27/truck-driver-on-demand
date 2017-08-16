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

    # @freelancers = @freelancers.reverse()
    @freelancers = @freelancers.page(params[:page]).per(5)
  end

  def hired
    @freelancers = current_company.
      freelancers.
      page(params[:page]).
      per(5)
  end

  def favourites
    @freelancers = current_company.
      favourite_freelancers.
      page(params[:page]).
      per(5)
  end


  def show
    @freelancer = Freelancer.find(params[:id])

    # analytic
    @freelancer.profile_views += 1
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

    if params.dig(:invite_to_quote)
      # TODO: Add this logic
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
