class Admin::NewRegistrantsController < Admin::BaseController

  def index
    authorize current_user
    freelancer_profiles = FreelancerProfile.new_registrants
    companies = Company.new_registrants
    @keywords = params.dig(:search, :keywords).presence
    @sort = params.dig(:search, :sort).presence

    if @keywords.present?
      freelancer_profiles = freelancer_profiles.name_or_email_search(@keywords)
      companies = companies.name_or_email_search(@keywords)
    end

    if @sort.blank? || @sort == 'created_at DESC'
      @new_registrants = (freelancer_profiles + companies).sort_by { |registrant| registrant.created_at }.reverse
    else
      if ['full_name', 'state', 'country', 'created_at', 'registration_step'].include?(@sort)
        @new_registrants = (freelancer_profiles + companies).sort_by { |registrant| registrant.try(@sort.to_sym) || "" }
      else
        @new_registrants = (freelancer_profiles + companies).sort_by { |registrant| registrant.user.try(@sort.to_sym) || "" }
      end
    end

    @new_registrants = Kaminari.paginate_array(@new_registrants).page(params[:page]).per(10)
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
