# frozen_string_literal: true

class Driver::JobsController < Driver::BaseController

  include JobHelper

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def index
    authorize current_user

    # rubocop:disable Metrics/LineLength
    if params[:search].nil? || (params[:search][:keywords].blank? && params[:search][:country].blank? && params[:search][:address].blank?)
      # rubocop:enable Metrics/LineLength
      flash[:error] = "You'll need to add some search criteria to narrow your search results!"
      redirect_to driver_root_path
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
        point = OpenStruct.new(lat: @geocode[:lat], lng: @geocode[:lng])
        @distance = 60_000
        @jobs = @jobs.nearby(@geocode[:lat], @geocode[:lng], @distance).with_distance(point).order("distance")
      else
        @jobs = Job.none
      end
    end

    @jobs = @jobs.search(@keywords) if @keywords
    @jobs = @jobs.where(country: @country) if @country

    @jobs = @jobs.page(params[:page]).per(10)
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  def show
    @job = Job.find(params[:id])
    authorize @job

    @have_applied = @job.applicants.where(driver_id: current_user.id).count != 0

    @favourite = !current_user.job_favourites.where(job_id: params[:id]).empty?
    return unless params.dig(:toggle_favourite) == "true"

    if @favourite == false
      current_user.favourite_jobs << @job
      @favourite = true
    else
      current_user.job_favourites.where(job_id: @job.id).destroy_all
      @favourite = false
    end
  end

  private

  def valid_company_jobs
    Job.joins(:company).where(companies: { disabled: false })
  end

  def apply_params
    params.require(:driver_job_apply_path).permit(
      :job,
      :message,
      :attachment,
      :body,
    )
  end

end
