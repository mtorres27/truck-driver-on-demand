class Company::BaseController < ApplicationController
  layout 'company/layouts/application'
  before_action :authenticate_company!

  def current_user
    current_company
  end
end
