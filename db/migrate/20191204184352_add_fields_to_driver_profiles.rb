class AddFieldsToDriverProfiles < ActiveRecord::Migration[5.1]
  def change
    remove_column :driver_profiles, :years_of_experience, :integer
    add_column :driver_profiles, :years_of_experience, :string
    add_column :driver_profiles, :business_name, :string
    add_column :driver_profiles, :hst_number, :string
  end
end
