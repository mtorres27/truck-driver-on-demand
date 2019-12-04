class AddCompletedProfileToDriverProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :driver_profiles, :completed_profile, :boolean, default: false
  end
end
