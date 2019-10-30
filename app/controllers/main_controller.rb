# frozen_string_literal: true

class MainController < ApplicationController

  before_action :redirect_if_logged_in, only: [:index]

  def index; end

  def privacy; end

  def terms; end

  def confirm_email; end

  def job_countries
    country = params[:country]
    return if country.blank?

    specs = Stripe::CountrySpec.retrieve(country.upcase)
    render partial: "job_currencies", locals: { currency: specs.default_currency } if specs.default_currency
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def freelance_service_agreement
    @job = Job.joins(:company).where(companies: { disabled: false }).where(id: params[:job])
    @months = %w[January February March April May June July August September October November December]

    if @job.length == 1
      @job = @job.first
      @job_start_day = @job.starts_on.day.to_s

      # rubocop:disable Metrics/LineLength
      if (@job_start_day[1] == "1") || (@job_start_day == "1") && (@job_start_day.to_i < 11) && (@job_start_day.to_i > 20)
        @job_start_day += "st"
      elsif (@job_start_day[1] == "2") || (@job_start_day == "2") && (@job_start_day.to_i < 11) && (@job_start_day.to_i > 20)
        @job_start_day += "nd"
      elsif (@job_start_day[1] == "3") || (@job_start_day == "3") && (@job_start_day.to_i < 11) && (@job_start_day.to_i > 20)
        @job_start_day += "rd"
      else
        @job_start_day += "th"
      end
      # rubocop:enable Metrics/LineLength

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
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  private

  def redirect_if_logged_in
    redirect_to after_sign_in_path_for(current_user) if current_user.present?
  end

end
