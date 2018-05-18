class Freelancer::BaseController < ApplicationController
  before_action :authenticate_user!
end
