class Freelancer::BaseController < ApplicationController
  layout 'freelancer/layouts/application'
  before_action :authenticate_user!

  def current_user
    current_freelancer
  end
end
