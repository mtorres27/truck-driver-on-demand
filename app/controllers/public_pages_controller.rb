class PublicPagesController < ApplicationController
  layout 'public_pages'

  def public_jobs
    if params[:search].present? && params[:search][:keywords].blank? && params[:search][:country].blank? && params[:search][:address].blank?
      flash[:error] = "You'll need to add some search criteria to narrow your search results!"
    end

    @keywords = params.dig(:search, :keywords).presence
    @country = params.dig(:search, :country).presence
    @address = params.dig(:search, :address).presence

    @jobs = valid_company_jobs.where(state: "published").all

    if @address
      # check for cached version of address
      @address_for_geocode = @address
      @address_for_geocode += ", #{CS.states(@country.to_sym)[@state_province.to_sym]}" if @state_province.present?
      @address_for_geocode += ", #{CS.countries[@country.upcase.to_sym]}" if @country.present?
      if Rails.cache.read(@address_for_geocode)
        @geocode = Rails.cache.read(@address_for_geocode)
      else
        # save cached version of address
        @geocode = do_geocode(@address_for_geocode)
        Rails.cache.write(@address_for_geocode, @geocode)
      end

      if @geocode
        point = OpenStruct.new(:lat => @geocode[:lat], :lng => @geocode[:lng])
        @distance = 60000
        @jobs = @jobs.nearby(@geocode[:lat], @geocode[:lng], @distance).with_distance(point).order("distance")
      else
        @jobs = Job.none
      end
    end

    @jobs = @jobs.search(@keywords) if @keywords
    @jobs = @jobs.where(country: @country) if @country

    @jobs = @jobs.page(params[:page]).per(10)
  end

  private

  def valid_company_jobs
    Job.joins(:company).where(companies: { disabled: false })
  end
end
