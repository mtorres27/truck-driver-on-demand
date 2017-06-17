class Company::BaseController < ApplicationController
  before_action :authenticate_company!

  layout "company"

  def current_user
    current_company
  end
end
