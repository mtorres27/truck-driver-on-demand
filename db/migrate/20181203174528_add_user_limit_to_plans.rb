class AddUserLimitToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :user_limit, :integer, default: 1
  end
end
