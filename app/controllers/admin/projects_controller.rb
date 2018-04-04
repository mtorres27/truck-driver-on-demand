class Admin::ProjectsController < Admin::BaseController

  before_action :set_project, only: [:show, :edit, :update, :destroy, :enable, :disable, :login_as]

  def index
    @keywords = params.dig(:search, :keywords).presence

    @projects = Project.order(:name)
    if @keywords
      @projects = @projects.search(@projects)
    end
    @projects = @projects.page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to admin_project_path(@project), notice: "Project updated."
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to admin_projects_path, notice: "Projects removed."
  end

  def enable
    @project.enable!
    redirect_to admin_projects_path, notice: "Project enabled."
  end

  def disable
    @projects.disable!
    redirect_to admin_projects_path, notice: "Project disabled."
  end

  private

    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(
        :name,
        :external_project_id,
        :area,
        :closed,
        :currency
      )
    end
end
