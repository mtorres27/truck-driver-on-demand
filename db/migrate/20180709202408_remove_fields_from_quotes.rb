class RemoveFieldsFromQuotes < ActiveRecord::Migration[5.1]
  def change
    remove_column :quotes, :amount, :decimal
    remove_column :quotes, :pay_type, :string
    remove_column :quotes, :number_of_hours, :integer
    remove_column :quotes, :number_of_days, :integer
    remove_column :quotes, :hourly_rate, :integer
    remove_column :quotes, :daily_rate, :integer
  end
end
