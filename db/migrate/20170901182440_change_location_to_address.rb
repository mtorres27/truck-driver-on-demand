class ChangeLocationToAddress < ActiveRecord::Migration[5.1]
  def change
    rename_column :jobs, :location, :address
  end
end
