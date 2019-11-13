class RemoveCountyFromDriverProfiles < ActiveRecord::Migration[5.1]
  def change
    remove_column :driver_profiles, :county, :string
  end
end
