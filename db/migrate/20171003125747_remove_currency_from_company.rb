class RemoveCurrencyFromCompany < ActiveRecord::Migration[5.1]
  def change
    remove_column :companies, :currency
  end
end
