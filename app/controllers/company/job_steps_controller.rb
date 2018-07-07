class Company::JobStepsController < Company::BaseController

  include Wicked::Wizard

  before_action :set_job, except: [:index]
  before_action :authorize_job, except: [:index]

  steps :job_details, :candidate_details

  def index
    redirect_to company_job_step_path(:job_details)
  end

  def show
    if params[:id] == "wicked_finish"
      if @job.creation_step != "wicked_finish"
        @job.update_attribute(:creation_step, "wicked_finish")
        flash[:notice] = "You need to publish this job in order to make it visible to freelancers"
      end
      redirect_to finish_wizard_path
    else
      render_wizard
    end
  end

  def update
    @job.attributes = params[:job] ? job_params : {}
    @job.creation_step = next_step

    @job.state = "published" if @job.creation_step == "wicked_finish"

    render_wizard @job
  end

  private

  def finish_wizard_path
    company_job_path(current_company.jobs.order(:updated_at).last)
  end

  def set_job
    if params[:id] == "job_details"
      @job = params[:job_id].present? ? current_company.jobs.find(params[:job_id]) : current_company.jobs.build
    else
      @job = params[:job_id].present? ? current_company.jobs.find(params[:job_id]) : current_company.jobs.last
    end
  end

  def authorize_job
    authorize @job
  end

  def validate_ownership
    unless job_params[:project_id].present? && current_company.projects.find(job_params[:project_id])
      @job.errors[:project_id] << "Invalid project selected"
    end
  end

  def job_params
    params.require(:job).permit(
        :project_id,
        :title,
        :summary,
        :scope_of_work,
        :scope_file,
        :budget,
        :country,
        :currency,
        :job_type,
        :job_market,
        :job_function,
        :pay_type,
        :starts_on,
        :duration,
        :freelancer_type,
        :invite_only,
        :scope_is_public,
        :budget_is_public,
        :state,
        :address,
        :state_province,
        attachments_attributes: [:id, :file, :title, :_destroy],
        technical_skill_tags:  I18n.t("enumerize.technical_skill_tags").keys,
        manufacturer_tags:  I18n.t("enumerize.manufacturer_tags").keys,
    )
  end
end
