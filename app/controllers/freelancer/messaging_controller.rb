# frozen_string_literal: true

class Freelancer::MessagingController < Freelancer::BaseController

  before_action :authorize_freelancer
  before_action :set_companies

  def index; end

  private

  def authorize_freelancer
    authorize current_user
  end

  def set_companies
    @companies = current_user.companies_for_messaging
  end

end
