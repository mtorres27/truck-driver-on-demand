class ActuallyUpdateDisabled < ActiveRecord::Migration[5.1]
  def change
    change_column :freelancers, :disabled, :boolean, default: true, index: true
    change_column :companies, :disabled, :boolean, default: true, index: true
  end
end
