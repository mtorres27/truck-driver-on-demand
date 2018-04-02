class Admin::PlansController < Admin::BaseController
  before_action :set_plan, only: [:show, :edit, :update, :destroy, :enable, :disable, :login_as]

  def index
    @plans = Plan.order(:name)
    @plans = @plans.page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    if @plan.update(plan_params)
      redirect_to admin_plan_path(@plan), notice: "Plan updated."
    else
      render :edit
    end
  end

  def destroy
    @plan.destroy
    redirect_to admin_projects_path, notice: "Plan removed."
  end

  private

    def set_plan
      @plan = Plan.find(params[:id])
    end

    def plan_params
      params.require(:plan).permit(
        :name,
        :code,
        :trial_period,
        :subscription_fee,
        :description,
        :period,
        fee_schema: ['below_2000', 'above_2000']
      )
    end
end