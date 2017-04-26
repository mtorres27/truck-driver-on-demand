class SessionsController < ApplicationController

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
        redirect_to "/#{section}", notice: "Signed in"
      else
        throw ActionController::InvalidAuthenticityToken
      end
    else
      throw ActionController::BadRequest
    end
  end

  def destroy
    if params[:section] == "freelancer"
      session[:freelancer_id] = nil
    elsif params[:section] == "company"
      session[:company_id] = nil
    elsif params[:section] == "admin"
      session[:admin_id] = nil
    else
      reset_session
    end
    redirect_to root_path, notice: "Signed out"
  end

  def failure
    redirect_to root_path, alert: "Authentication error: #{failure_message}"
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
