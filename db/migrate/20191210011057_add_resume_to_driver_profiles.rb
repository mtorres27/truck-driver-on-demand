class AddResumeToDriverProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :driver_profiles, :resume_data, :text
    add_column :driver_profiles, :resume_uploaded, :boolean, default: false
  end
end
