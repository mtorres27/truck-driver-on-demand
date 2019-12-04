class AddAddressToDriverProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :driver_profiles, :address_line1, :string
    add_column :driver_profiles, :address_line2, :string
  end
end
