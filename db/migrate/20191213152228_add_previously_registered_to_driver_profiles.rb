class AddPreviouslyRegisteredToDriverProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :driver_profiles, :previously_registered_with_tpi, :boolean
  end
end
