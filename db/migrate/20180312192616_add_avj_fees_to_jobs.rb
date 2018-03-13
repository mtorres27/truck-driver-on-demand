class AddAvjFeesToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :company_plan_fees, :integer, default: 0
  end
end
