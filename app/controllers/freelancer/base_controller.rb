class Freelancer::BaseController < ApplicationController
  layout 'freelancer/layouts/application'
  before_action :authenticate_user!
  before_action :redirect_if_not_freelancer

  helper_method :current_freelancer_profile

  private

  def current_freelancer_profile
    @current_freelancer_profile ||= current_user&.freelancer_profile
  end

  def redirect_if_not_freelancer
    redirect_to root_path unless current_user&.freelancer?
  end

  def current_freelancer_registering?
    !current_user&.freelancer_profile&.registration_completed?
  end
end
