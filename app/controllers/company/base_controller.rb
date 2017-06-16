class Company::BaseController < ApplicationController
  before_action :authenticate_company!

  layout "company"
end
