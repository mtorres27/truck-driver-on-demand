class RemoveCoordinatesFromMessages < ActiveRecord::Migration[5.1]
  def change
    remove_column :messages, :lat
    remove_column :messages, :lng
  end
end
