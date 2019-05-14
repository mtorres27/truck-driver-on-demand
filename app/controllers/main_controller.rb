class MainController < ApplicationController
  before_action :redirect_if_logged_in, only: [:index]

  def login 
  end

  def company_register 
  end

  def search_professionals
  end

  def messages
  end

  def message_detail
  end

  def search_results
  end

  def jobs
  end

  def job_detail
  end

  def job_post_form
  end

  def company_profile 
  end

  def company_profile_edit 
  end

  def index
  end

  def privacy
  end

  def terms
  end

  def confirm_email

  end

  def job_countries
    country = params[:country]
    return if country.blank?
    specs = Stripe::CountrySpec.retrieve(country.upcase)
    render partial: "job_currencies", locals: { currency: specs.default_currency } if specs.default_currency
  end

  def freelance_service_agreement
    @job = Job.joins(:company).where(:companies => {:disabled => false}).where({id: params[:job]})
    @months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    if @job.length == 1
      @job = @job.first
      @job_start_day = @job.starts_on.day.to_s

      if @job_start_day[1] == "1" or @job_start_day == "1" and @job_start_day.to_i < 11 and @job_start_day.to_i > 20
        @job_start_day += "st"
      elsif @job_start_day[1] == "2" or @job_start_day == "2" and @job_start_day.to_i < 11 and @job_start_day.to_i > 20
        @job_start_day += "nd"
      elsif @job_start_day[1] == "3" or @job_start_day == "3" and @job_start_day.to_i < 11 and @job_start_day.to_i > 20
        @job_start_day += "rd"
      else
        @job_start_day += "th"
      end

      @job_start_month = @months[@job.starts_on.month]



      @job_start_year = @job.starts_on.year

      if @job.freelancer.nil?
        @job = nil
      elsif current_user.freelancer? && @job.freelancer.id != current_user.id
        @job = nil
      elsif current_user.company_user? && @job.company.id != current_user.company.id
        @job = nil
      end
    else
      @job = nil
    end
  end

  private

  def redirect_if_logged_in
    if current_user.present?
      redirect_to after_sign_in_path_for(current_user)
    end
  end
end
