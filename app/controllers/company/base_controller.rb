class Company::BaseController < ApplicationController
  layout 'company/layouts/application'
  before_action :authenticate_user!
end
