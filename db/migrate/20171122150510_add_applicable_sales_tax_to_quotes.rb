# frozen_string_literal: true

class AddApplicableSalesTaxToQuotes < ActiveRecord::Migration[5.1]
  def change
    add_column :quotes, :applicable_sales_tax, :integer, null: true
  end
end
