class AddTaxationFieldsToRelevantTables < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :tax_amount, :decimal, precision: 10, scale: 2
    add_column :payments, :total_amount, :decimal, precision: 10, scale: 2

    add_column :quotes, :tax_amount, :decimal, precision: 10, scale: 2
    add_column :quotes, :total_amount, :decimal, precision: 10, scale: 2
  end
end
