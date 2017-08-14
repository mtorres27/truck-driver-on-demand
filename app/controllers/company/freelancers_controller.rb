class Company::FreelancersController < Company::BaseController
  include FreelancerHelper

  def index
    @keywords = params.dig(:search, :keywords).presence
    @address = params.dig(:search, :address).presence

    @sort = params.dig(:search, :sort).presence

    if @sort == "ASC"
      sort = :asc
    elsif @sort == "DESC"
      sort = :desc
    else
      sort = :asc
    end

    @freelancers = Freelancer.order(name: sort)

    if @address
      @geocode = do_geocode(@address)

      if @geocode
        @freelancers = @freelancers.near(@geocode[:lat],@geocode[:lng],60000)
      else
        @freelancers = Freelancer.none
      end
    end

    if @keywords
      @freelancers = @freelancers.search(@keywords)
    end

    @freelancers = @freelancers.page(params[:page]).per(5)
  end

  def hired
    @freelancers = current_company.
      freelancers.
      page(params[:page]).
      per(5)
  end

  def show
    Freelancer.find(params[:id])
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
