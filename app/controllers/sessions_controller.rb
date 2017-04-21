class SessionsController < ApplicationController

  def new
    @section = request.params[:section] || 'freelancer'
  end

  def create
    auth_hash = request.env["omniauth.auth"]

    unless auth_hash
      render "No authentication hash returned from provider."
      return
    end

    if request.env["omniauth.params"]&.dig(:section) == "company"
      render text: "TODO: Company Login"

    else
      freelancer = Freelancer.find_or_create_from_auth_hash(auth_hash: auth_hash)
      # reset_session
      session[:freelancer_id] = freelancer.id
      redirect_to freelancer_root_path, notice: "Signed in"
    end
  end

  def destroy
    reset_session
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
