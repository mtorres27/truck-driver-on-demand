class Freelancer::BaseController < ApplicationController
  before_action :authenticate_freelancer!

  layout "freelancer"

  def current_user
    current_freelancer
  end
end
