class Freelancer::BaseController < ApplicationController
  layout 'freelancer/layouts/application'
  before_action :authenticate_freelancer!

  def current_user
    current_freelancer
  end
end
