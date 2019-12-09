class AddDrivingSchoolToDriverProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :driver_profiles, :driving_school, :string
  end
end
