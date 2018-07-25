class Admin::PlansController < Admin::BaseController
  before_action :set_plan, except: [:index]
  before_action :authorize_plan, except: [:index]

  def index
    authorize current_user
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

  def authorize_plan
    authorize @plan
  end

  def plan_params
    params.require(:plan).permit(
      :name,
      :code,
      :trial_period,
      :subscription_fee,
      :description,
      :period,
      fee_schema: ['avj_fees', 'freelancer_fees']
    )
  end
end