class AddApplicableSalesTaxToJob < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :applicable_sales_tax, :decimal, precision: 10, scale: 2, :null => true
  end
end
