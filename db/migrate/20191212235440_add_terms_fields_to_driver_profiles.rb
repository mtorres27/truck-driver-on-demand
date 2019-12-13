class AddTermsFieldsToDriverProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :driver_profiles, :accept_health_and_safety, :boolean, default: false
    add_column :driver_profiles, :accept_excess_hours, :boolean, default: false
    add_column :driver_profiles, :accept_terms_and_conditions, :boolean, default: false
  end
end
