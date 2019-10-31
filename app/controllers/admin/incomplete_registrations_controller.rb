# frozen_string_literal: true

class Admin::IncompleteRegistrationsController < Admin::BaseController

  def index
    authorize current_user
    freelancer_profiles = FreelancerProfile.incomplete_registrations
    companies = Company.incomplete_registrations
    @keywords = params.dig(:search, :keywords).presence
    @sort = params.dig(:search, :sort).presence

    if @keywords.present?
      freelancer_profiles = freelancer_profiles.name_or_email_search(@keywords)
      companies = companies.name_or_email_search(@keywords)
    end

    if @sort.blank? || @sort == "created_at DESC"
      @registrants = (freelancer_profiles + companies).sort_by(&:created_at).reverse
    else
      @registrants = if %w[full_name state country created_at].include?(@sort)
                       (freelancer_profiles + companies).sort_by { |registrant| registrant.try(@sort.to_sym) || "" }
                     else
                       # rubocop:disable Metrics/LineLength
                       (freelancer_profiles + companies).sort_by { |registrant| registrant.user.try(@sort.to_sym) || "" }
                       # rubocop:enable Metrics/LineLength
                     end
    end

    @registrants = Kaminari.paginate_array(@registrants).page(params[:page]).per(10)
  end

  def download_csv
    authorize current_user
    freelancers = FreelancerProfile.incomplete_registrations.map(&:freelancer)
    companies = Company.incomplete_registrations.map(&:owner)
    @registrants = (freelancers + companies).sort_by(&:created_at).reverse
    create_csv

    send_data @csv_file,
              type: "text/csv; charset=iso-8859-1; header=present",
              disposition: "attachment; filename=incomplete_registrations.csv"
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
