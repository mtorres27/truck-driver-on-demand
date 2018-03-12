class AddPeriodToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :period, :string,  default: "yearly"
    change_column :plans, :subscription_fee, :decimal, precision: 10, scale: 2
  end
end
