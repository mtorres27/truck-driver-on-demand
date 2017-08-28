class AddCurrencyToPrroject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :currency, :string
  end
end
