class Company::BaseController < ApplicationController
  before_action :authenticate_company!

  layout "company"

  private

    def set_job
      @job = Job.find(params[:job_id])
      unless @job.project.company_id == current_company.id
        redirect_to company_projects_path, error: "Invalid project selected."
      end
    end

end
