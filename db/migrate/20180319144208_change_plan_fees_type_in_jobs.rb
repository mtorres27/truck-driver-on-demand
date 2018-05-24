class ChangePlanFeesTypeInJobs < ActiveRecord::Migration[5.1]
  def change
    change_column :jobs, :company_plan_fees, :decimal, precision: 10, scale: 2, default: 0
  end
end
