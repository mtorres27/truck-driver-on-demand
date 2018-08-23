class Admin::IncompleteRegistrationsController < Admin::BaseController

  def index
    authorize current_user
    freelancers = FreelancerProfile.incomplete_registrations
    companies = Company.incomplete_registrations
    @keywords = params.dig(:search, :keywords).presence
    if @keywords.present?
      freelancers = freelancers.name_or_email_search(@keywords)
      companies = companies.name_or_email_search(@keywords)
    end
    @registrants = (freelancers + companies).sort_by { |registrant| registrant.created_at }.reverse
  end

  def download_csv
    authorize current_user
    freelancers = FreelancerProfile.incomplete_registrations.map(&:freelancer)
    companies = Company.incomplete_registrations.map(&:company_user)
    @registrants = (freelancers + companies).sort_by { |registrant| registrant.created_at }.reverse
    create_csv
    send_data @csv_file, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => 'attachment; filename=incomplete_registrations.csv'
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
