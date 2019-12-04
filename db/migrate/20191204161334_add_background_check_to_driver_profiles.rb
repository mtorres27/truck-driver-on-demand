class AddBackgroundCheckToDriverProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :driver_profiles, :background_check_data, :text
  end
end
