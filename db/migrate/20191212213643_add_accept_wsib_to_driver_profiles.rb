class AddAcceptWsibToDriverProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :driver_profiles, :accept_wsib, :boolean, default: false
  end
end
