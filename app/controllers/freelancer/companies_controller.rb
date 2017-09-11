class Freelancer::CompaniesController < Freelancer::BaseController
  include CompanyHelper

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
      @jobs = Job.where({ state: "published" }).order(name: sort)
    else
      @jobs = Job.where({ state: "published" }).all
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
        @jobs = @jobs.nearby(@geocode[:lat], @geocode[:lng], @distance).with_distance(point).order("distance")
      else
        @jobs = Job.none
      end
    end

    if @keywords
      @jobs = @jobs.search(@keywords)
    end

    @jobs = @jobs.page(params[:page]).per(50)
  end

  def worked_for
    @locations = current_freelancer.companies.uniq.pluck(:area)
    @companies = current_freelancer.companies

    if params[:location] && params[:location] != ""
      @companies = @companies.where({ area: params[:location] })
    end
    
    @companies = @companies.page(params[:page]).
      per(50)
  end

  def favourites
    @locations = current_freelancer.favourite_companies.uniq.pluck(:area)
    @companies = current_freelancer.favourite_companies

    if params[:location] && params[:location] != ""
      @companies = @companies.where({ area: params[:location] })
    end

    @companies = @companies.page(params[:page]).
      per(50)
  end


  def show_company
    @company = Company.find(params[:id])

    # analytic
    @company.profile_views += 1
    @company.save

    @favourite = current_freelancer.favourites.where({company_id: params[:id]}).length > 0 ? true : false
    if params.dig(:toggle_favourite) == "true"
      if @favourite == false
        current_freelancer.favourite_companies << @company
        @favourite = true
      else
        current_freelancer.favourites.where({company_id: @company.id}).destroy_all
        @favourite = false
      end
    end

    
  end


  def show_job
    @job = Job.find(params[:id])
  end


  def add_favourites
    if params[:companies].nil?
      render json: { status: 'parameter missing' }
      return
    end

    params[:companies].each do |id|
      c = Company.where({ id: id.to_i })

      if f.length > 0
        current_freelancer.favourite_companies << c.first
      end
    end
          
    render json: { status: 'success', companies: params[:companies] }

  end

end
