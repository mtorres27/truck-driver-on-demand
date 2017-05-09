# frozen_string_literal: true
class Company::BaseController < ApplicationController
  before_action :authenticate_company!

  layout "company"

  helper_method :current_company
  helper_method :company_signed_in?

  private

    def current_company
      begin
        @current_company ||= Company.find(session[:company_id]) if session[:company_id]
      rescue Exception => e
        nil
      end
    end

    def company_signed_in?
      return true if current_company
    end

    def authenticate_company!
      unless current_company
        redirect_to new_session_path(section: "company"), alert: "You must be logged in to access the company section."
      end
    end

    def set_job
      @job = Job.find(params[:job_id])
      unless @job.project.company_id == current_company.id
        redirect_to company_projects_path, error: "Invalid project selected."
      end
    end

end
