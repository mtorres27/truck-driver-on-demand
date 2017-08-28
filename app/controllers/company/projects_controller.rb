class Company::ProjectsController < Company::BaseController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects =
      current_company.
      projects.
      includes(jobs: :payments).
      where(closed: params[:closed].present?).
      order({ external_project_id: :desc, id: :desc }).
      page(params[:page]).
      per(50)

    @job_count = Job.joins(:project).where(
      projects: {
        company_id: current_company.id,
        closed: params[:closed].present?
      }).count

      @currencies = [
        ["Canadian Dollars", "cad"],
        ["Euro", "euro"],
        ["Ruble", "ruble"],
        ["Rupee", "rupee"],
        ["US Dollars", "usd"],
        ["Yen", "yen"]
      ]
  end

  def new
    @project = current_company.projects.new
    @currencies = [
      ["Canadian Dollars", "cad"],
      ["Euro", "euro"],
      ["Ruble", "ruble"],
      ["Rupee", "rupee"],
      ["US Dollars", "usd"],
      ["Yen", "yen"]
    ]
  end

  def create
    @project = current_company.projects.new(project_params)

    if @project.save
      respond_to do |format|
        format.html { redirect_to company_projects_path, notice: "Project created." }
        format.js
        format.json { render json: @project, status: :created }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js
        format.json { render json: @project, status: :unprocessable_entity }
      end
    end
  end

  def show
    @currencies = [
      ["Canadian Dollars", "cad"],
      ["Euro", "euro"],
      ["Ruble", "ruble"],
      ["Rupee", "rupee"],
      ["US Dollars", "usd"],
      ["Yen", "yen"]
    ]
  end

  def edit
    @currencies = [
      ["Canadian Dollars", "cad"],
      ["Euro", "euro"],
      ["Ruble", "ruble"],
      ["Rupee", "rupee"],
      ["US Dollars", "usd"],
      ["Yen", "yen"]
    ]
  end

  def update
    if @project.update(project_params)
      redirect_to company_projects_path
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to company_projects_path, notice: "Project removed."
  end


  private

    def set_project
      @project = current_company.projects.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:name, :external_project_id, :budget, :currency, :address, :starts_on, :duration)
    end
end
