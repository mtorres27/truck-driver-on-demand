class AddDriverAbstractToDriverProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :driver_profiles, :driver_abstract_data, :text
    add_column :driver_profiles, :driver_abstract_uploaded, :boolean, default: false
  end
end
