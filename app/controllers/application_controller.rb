class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  require "erb"
  include ERB::Util

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_to_registration_step, if: :current_company_registering? || :current_freelancer_registering?

  before_action do
    if Rails.env.development?
      # Rack::MiniProfiler.authorize_request
    end
  end

  def after_inactive_sign_up_path_for(resource)
    cookies.delete(:onboarding)
    '/confirm_email'
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(Freelancer)
      return freelancer_root_path if resource.registration_completed? || resource.registration_step.nil?
      return freelancer_registration_step_path(resource.registration_step)
    elsif resource.is_a?(Company)
      return company_root_path if resource.registration_completed? || resource.registration_step.nil?
      return company_registration_step_path(resource.registration_step)
    else
      super
    end
  end

  def current_company_registering?
    # unless current_company&.registration_step
    #   current_company &&
    #   !current_company.registration_completed? &&
    #   !(request.original_fullpath.include? company_registration_step_path(current_company.registration_step)) &&
    #   request.original_fullpath != destroy_company_session_path
    # end
    false
  end

  def current_freelancer_registering?
    # unless current_freelancer&.registration_step
    #   current_freelancer &&
    #   !current_freelancer.registration_completed? &&
    #   !(request.original_fullpath.include? freelancer_registration_step_path(current_freelancer.registration_step)) &&
    #   request.original_fullpath != destroy_freelancer_session_path
    # end
    false
  end

  def redirect_to_registration_step
    redirect_to company_registration_step_path(current_company.registration_step) if current_company
    redirect_to freelancer_registration_step_path(current_freelancer.registration_step) if current_freelancer
  end

  def do_geocode(address)
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{url_encode(address)}&key=#{Rails.application.secrets.google_maps_api_key}"
    # Make the API request
    begin
      res = JSON.parse(Net::HTTP.get(URI.parse(url)), symbolize_names: true)
      if res[:status] == "OK"
        formatted_address = res[:results][0][:formatted_address]
        lat = res[:results][0][:geometry][:location][:lat]
        lng = res[:results][0][:geometry][:location][:lng]

        return { address: formatted_address, lat: lat, lng: lng }
      end
    rescue Exception => e
      puts e
      logger.error e
      return false
    end
  end

  protected

  def after_sign_in_path_for(resource)
    if resource.type == 'Admin'
      admin_root_path
    elsif resource.type == 'Freelancer'
      freelancer_root_path
    elsif resource.type == 'Company'
      company_root_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(
        :email,
        :password,
        :password_confirmation,
        :name,
        :contact_name,
        :country,
        :city,
        :state,
        :currency,
        :accept_terms_of_service,
        :accept_privacy_policy,
        :accept_code_of_conduct
      )
    end
  end

end
