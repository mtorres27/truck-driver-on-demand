class AddExtraFieldsToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :current_plan_id, :integer
    add_column :companies, :is_trial_applicable, :boolean, default: true
  end
end
