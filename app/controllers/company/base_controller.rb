class Company::BaseController < ApplicationController
  before_action :authenticate_user!

  def current_user
    current_company
  end
end
