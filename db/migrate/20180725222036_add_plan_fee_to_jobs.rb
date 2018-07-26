class AddPlanFeeToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :plan_fee, :decimal, precision: 10, scale: 2, default: 0
  end
end
