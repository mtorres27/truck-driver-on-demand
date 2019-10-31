# frozen_string_literal: true

class Company::FreelancersController < Company::BaseController

  include FreelancerHelper

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def index
    @keywords = params.dig(:search, :keywords).presence
    @address = params.dig(:search, :address).presence
    @country = params.dig(:search, :country).presence
    @job_type = params.dig(:search, :job_type).presence
    @job_function = params.dig(:search, :job_function).presence

    if params.key?(:search) && !@country
      @freelancer_profiles = FreelancerProfile.none.page(params[:page]).per(10)
      return
    end

    @distance = params.dig(:search, :distance).presence

    @freelancer_profiles = FreelancerProfile.where(disabled: false, country: @country)

    if @job_type.present?
      job_markets = I18n.t("enumerize.#{@job_type}_job_markets").keys.map { |val| "%#{val}%" }
      @freelancer_profiles = @freelancer_profiles.where("job_markets ilike any ( array[?] )", job_markets)
    end
    if @job_function.present?
      @freelancer_profiles = @freelancer_profiles.where("job_functions like ?", "%#{@job_function}%")
    end

    if @address.present?
      @address_for_geocode = @address + ", " + @country.upcase

      # check for cached version of address
      if Rails.cache.read(@address_for_geocode)
        @geocode = Rails.cache.read(@address_for_geocode)
      else
        # save cached version of address
        @geocode = do_geocode(@address_for_geocode)
        Rails.cache.write(@address_for_geocode, @geocode)
      end

      if @geocode
        point = OpenStruct.new(lat: @geocode[:lat], lng: @geocode[:lng])
        @distance_int = if @distance.nil?
                          60_000
                        else
                          @distance.to_i
                        end
        # rubocop:disable Metrics/LineLength
        @freelancer_profiles = @freelancer_profiles.nearby(@geocode[:lat], @geocode[:lng], @distance_int).with_distance(point).order("verified DESC, profile_score DESC, distance")
        # rubocop:enable Metrics/LineLength
      else
        @freelancer_profiles = FreelancerProfile.none
      end
    else
      @address_for_geocode = I18n.t("enumerize.country.#{@country}")
      @freelancer_profiles = @freelancer_profiles.order("verified DESC, profile_score DESC")
    end

    @freelancer_profiles = @freelancer_profiles.search(@keywords) if @keywords.present?

    @freelancer_profiles_with_distances = @freelancer_profiles
    @freelancer_profiles = @freelancer_profiles.page(params[:page]).per(10)
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

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

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def show
    hashids = Hashids.new(ENV["hash_ids_salt"], 8)
    id = hashids.decode(params[:id])

    if id.count.zero?
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
      @jobs << job if @found == false
    end

    # analytic
    if (params.dig(:toggle_favourite) != "true") && (params.dig(:invite_to_quote) != "true")
      @freelancer.freelancer_profile.profile_views += 1
    end
    @freelancer.freelancer_profile.save

    @favourite = !current_company.freelancers.where(id: id).empty?
    if params.dig(:toggle_favourite) == "true"
      if @favourite == false
        # rubocop:disable Metrics/LineLength
        current_company.update_attribute(:saved_freelancers_ids, current_company.saved_freelancers_ids + [@freelancer.id])
        # rubocop:enable Metrics/LineLength
        @favourite = true
      else
        # rubocop:disable Metrics/LineLength
        current_company.update_attribute(:saved_freelancers_ids, current_company.saved_freelancers_ids - [@freelancer.id])
        # rubocop:enable Metrics/LineLength
        @favourite = false
      end
    end

    if (params.dig(:invite_to_quote) == "true") && (params.dig(:result).to_i == 1)
      @invite_sent = true
    elsif (params.dig(:invite_to_quote) == "true") && params.dig(:result).to_i.zero?
      @invite_error = 1
    elsif (params.dig(:invite_to_quote) == "true") && (params.dig(:result).to_i == 2)
      @invite_error = 2
    elsif (params.dig(:invite_to_quote) == "true") && (params.dig(:result).to_i == 3)
      @invite_error = 3
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

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
