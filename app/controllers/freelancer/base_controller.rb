class Freelancer::BaseController < ApplicationController
  layout 'freelancer/layouts/application'
  before_action :authenticate_user!
end
