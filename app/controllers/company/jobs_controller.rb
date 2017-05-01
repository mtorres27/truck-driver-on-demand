class Company::JobsController < Company::BaseController
  before_action :set_project, only: [:new, :show, :edit, :update, :destroy]
  before_action :set_job, only: [:show, :edit, :update, :destroy]

  def new
    @job = @project ? @project.jobs.new : Job.new
  end

  def create
    @project = current_company.projects.find(job_params[:project_id])
    @job = @project.jobs.new

    if @job.save
      redirect_to company_project_job_path(@project, @job), notice: "Job created."
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
      params.require(:job).permit(:project_id, :name)
    end
end
