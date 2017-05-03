class Company::JobsController < Company::BaseController
  before_action :set_project, only: [:new, :show, :edit, :update, :destroy]
  before_action :set_job, only: [:show, :edit, :update, :destroy]

  def new
    @job = @project ? @project.jobs.new : Job.new
  end

  def create
    @job = Job.new(job_params)

    # Don't let the user assign a project that doesn't belong to them.
    unless @job.project&.company&.id == current_company.id
      @job.errors[:project_id] << "Invalid project selected"
      render :new
      return
    end

    if job_params[:published]
      logger.debug("Published button: #{job_params[:published]}")
      @job.published = true
    end

    if @job.save
      redirect_to company_project_job_path(@job.project, @job), notice: "Job created."
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @job.update(job_params)
      redirect_to company_project_job_path(@project, @job), notice: "Job updated."
    else
      render :edit
    end
  end

  def destroy
    @job.destroy
    redirect_to company_project_path(@project), notice: "Job removed."
  end


  private

    def set_project
      @project = current_company.projects.find(params[:project_id]) if params[:project_id]
    end

    def set_job
      @job = @project.jobs.find(params[:id])
    end

    def job_params
      params.require(:job).permit(
        :project_id,
        :title,
        :summary,
        :scope_of_work,
        :budget,
        :job_function,
        :starts_on,
        :duration,
        :pay_type,
        :freelancer_type,
        :keywords,
        :invite_only,
        :scope_is_public,
        :budget_is_public,
        :publish
      )
    end
end
