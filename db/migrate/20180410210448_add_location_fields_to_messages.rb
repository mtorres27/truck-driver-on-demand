class AddLocationFieldsToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :lat, :decimal, precision: 9, scale: 6
    add_column :messages, :lng, :decimal, precision: 9, scale: 6
  end
end
