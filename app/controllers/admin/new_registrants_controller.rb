class Admin::NewRegistrantsController < Admin::BaseController

  def index
    authorize current_user
    freelancers = FreelancerProfile.new_registrants
    companies = Company.new_registrants
    @new_registrants = (freelancers + companies).sort_by { |registrant| registrant.created_at }.reverse
  end

  def download_csv
    authorize current_user
    freelancers = FreelancerProfile.new_registrants.map(&:freelancer)
    companies = Company.new_registrants.map(&:company_user)
    @registrants = (freelancers + companies).sort_by { |registrant| registrant.created_at }.reverse
    create_csv
    send_data @csv_file, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => 'attachment; filename=new_registrants.csv'
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
