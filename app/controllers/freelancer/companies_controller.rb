# frozen_string_literal: true

class Freelancer::CompaniesController < Freelancer::BaseController

  include CompanyHelper

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def index
    authorize current_user

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

    # TODO: MAKE THIS ONLY SHOW JOBS WHERE COMPANY ISN'T DISABLED

    @jobs = if !sort.nil?
              Job.joins(:company).where(companies: { disabled: false }).where(state: "published").order(name: sort)
            else
              Job.joins(:company).where(companies: { disabled: false }).where(state: "published").all
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
        point = OpenStruct.new(lat: @geocode[:lat], lng: @geocode[:lng])
        @distance = 60_000 if @distance.nil?
        @jobs = @jobs.nearby(@geocode[:lat], @geocode[:lng], @distance).with_distance(point).order("distance")
      else
        @jobs = Job.none
      end
    end

    @jobs = @jobs.search(@keywords) if @keywords && !@keywords.blank?

    @jobs = @jobs.page(params[:page]).per(50)
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  def favourites
    authorize current_user

    @locations = current_user.favourite_companies.uniq.pluck(:area)
    @companies = current_user.favourite_companies

    current_user.favourite_jobs.each do |job|
      @locations << job.company.area
      @companies << job.company
    end

    @locations = @locations.uniq
    @companies = @companies.uniq
  end

  def show
    @company = Company.find(params[:id])
    authorize @company

    # analytic
    @company.profile_views += 1
    @company.save

    @favourite = !current_user.company_favourites.where(company_id: params[:id]).empty?
    return unless params.dig(:toggle_favourite) == "true"

    if @favourite == false
      current_user.favourite_companies << @company
      @favourite = true
    else
      current_user.company_favourites.where(company_id: @company.id).destroy_all
      @favourite = false
    end
  end

  def av_companies
    authorize current_user

    @locations = []
    @companies = []

    if params[:location] && params[:location] != ""
      current_user.applicants.where(state: "accepted").where(city: params[:location]).each do |job|
        @locations << job.company.area
        @companies << job.company
      end
    else

      current_user.applicants.where(state: "accepted").each do |job|
        @locations << job.company.area
        @companies << job.company
      end
    end

    @locations = @locations.uniq
    @companies = @companies.uniq
  end

  def show_job
    @job = Job.find(params[:id])
    authorize @job, :show?
  end

  def add_favourites
    authorize current_user
    if params[:companies].nil?
      render json: { status: "parameter missing" }
      return
    end
    params[:companies].each do |id|
      c = Company.where(id: id.to_i)

      current_user.favourite_companies << c.first unless f.empty?
    end

    render json: { status: "success", companies: params[:companies] }
  end

end
