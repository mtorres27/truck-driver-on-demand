# frozen_string_literal: true
class Freelancer::BaseController < ApplicationController
  before_action :authenticate_freelancer!

  layout "freelancer"

  helper_method :current_freelancer
  helper_method :freelancer_signed_in?

  private

  def current_freelancer
    begin
      @current_freelancer ||= Freelancer.find(session[:freelancer_id]) if session[:freelancer_id]
    rescue Exception => e
      nil
    end
  end

  def freelancer_signed_in?
    return true if current_freelancer
  end

  def authenticate_freelancer!
    unless current_freelancer
      redirect_to new_session_path(section: "freelancer"), alert: "You must be logged in to access the freelancer section."
    end
  end

end
