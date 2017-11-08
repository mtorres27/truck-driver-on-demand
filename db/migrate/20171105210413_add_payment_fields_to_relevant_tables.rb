class AddPaymentFieldsToRelevantTables < ActiveRecord::Migration[5.1]
  def change
    add_column :quotes, :paid_by_company, :boolean, default: false
    add_column :quotes, :paid_at, :datetime
    add_column :quotes, :platform_fees_amount, :decimal, precision: 10, scale: 2
  end
end
