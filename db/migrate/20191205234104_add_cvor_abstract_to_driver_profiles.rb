class AddCvorAbstractToDriverProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :driver_profiles, :cvor_abstract_data, :text
    add_column :driver_profiles, :cvor_abstract_uploaded, :boolean, default: false
  end
end
