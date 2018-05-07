class AddExtraFieldsToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_reference :companies, :plan, foreign_key: { to_table: :plans }, index: true
    add_column :companies, :is_trial_applicable, :boolean, default: true
  end
end
