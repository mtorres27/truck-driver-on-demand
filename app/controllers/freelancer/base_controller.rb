class Freelancer::BaseController < ApplicationController
  before_action :authenticate_freelancer!

  layout "freelancer"
end
