# frozen_string_literal: true

class Admin::NewRegistrantsController < Admin::BaseController

  def index
    authorize current_user
    driver_profiles = DriverProfile.new_registrants
    companies = Company.new_registrants
    @keywords = params.dig(:search, :keywords).presence
    @sort = params.dig(:search, :sort).presence

    if @keywords.present?
      driver_profiles = driver_profiles.name_or_email_search(@keywords)
      companies = companies.name_or_email_search(@keywords)
    end

    if @sort.blank? || @sort == "created_at DESC"
      @new_registrants = (driver_profiles + companies).sort_by(&:created_at).reverse
    else
      @new_registrants = if %w[full_name state country created_at registration_step].include?(@sort)
                           (driver_profiles + companies).sort_by { |registrant| registrant.try(@sort.to_sym) || "" }
                         else
                           # rubocop:disable Metrics/LineLength
                           (driver_profiles + companies).sort_by { |registrant| registrant.user.try(@sort.to_sym) || "" }
                           # rubocop:enable Metrics/LineLength
                         end
    end

    @new_registrants = Kaminari.paginate_array(@new_registrants).page(params[:page]).per(10)
  end

  def download_csv
    authorize current_user
    drivers = DriverProfile.new_registrants.map(&:driver)
    companies = Company.new_registrants.map(&:owner)
    @registrants = (drivers + companies).sort_by(&:created_at).reverse
    create_csv
    # rubocop:disable Metrics/LineLength
    send_data @csv_file, type: "text/csv; charset=iso-8859-1; header=present", disposition: "attachment; filename=new_registrants.csv"
    # rubocop:enable Metrics/LineLength
  end

  private

  def create_csv
    @csv_file = CSV.generate({}) do |csv|
      csv << @registrants.first.attributes.keys unless @registrants.first.nil?
      @registrants.each do |f|
        csv << f.attributes.values
      end
    end
  end

end
