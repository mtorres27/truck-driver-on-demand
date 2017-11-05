class AddPaymentFieldsToRelevantTables < ActiveRecord::Migration[5.1]
  def change
    add_column :quotes, :paid_by_company, :boolean, default: false
    add_column :quotes, :paid_at, :datetime
  end
end
