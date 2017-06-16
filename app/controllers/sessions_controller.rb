class SessionsController < ApplicationController
  include LoginAs

  def new
    @section = request.params[:section] || 'freelancer'
  end

  def create
    params_hash = request.env["omniauth.params"]
    auth_hash = request.env["omniauth.auth"]

    unless auth_hash
      render "No authentication hash returned from provider."
      return
    end

    if params_hash
      params_hash.deep_symbolize_keys!
    end

    section = params_hash&.dig(:section)
    if %w(admin company freelancer).include?(section)
      user = section.camelize.constantize.find_or_create_from_auth_hash(auth_hash)
      if user
        session["#{section}_id"] = user.id
        session["#{section}_token"] = user.token
        redirect_to "/#{section}", notice: "Signed in"
      else
        throw ActionController::InvalidAuthenticityToken
      end
    else
      throw ActionController::BadRequest
    end
  end

  def destroy
    section = params[:section]
    if section.present?
      session["#{section}_id".to_sym] = nil
      session["#{section}_token".to_sym] = nil
    else
      reset_session
    end
    redirect_to root_path, notice: "Signed out"
  end

  def failure
    redirect_to root_path, alert: "Authentication error: #{failure_message}"
  end

  # For development only
  def login_as
    # throw ActionController::BadRequest unless Rails.env.development?
    super
  end

  protected

  def failure_message
    exception = env["omniauth.error"]
    Rails.logger.warn "exception: #{exception.inspect}"
    error = exception.error_reason if exception.respond_to?(:error_reason)
    error ||= exception.error if exception.respond_to?(:error)
    error ||= env["omniauth.error.type"].to_s
    error.to_s.humanize if error
  end

end
