class RefactorDriverProfiles < ActiveRecord::Migration[5.1]
  def change
    # Remove freelancer columns
    remove_column :driver_profiles, :address, :string
    remove_column :driver_profiles, :formatted_address, :string
    remove_column :driver_profiles, :country, :string
    remove_column :driver_profiles, :driver_team_size, :string
    remove_column :driver_profiles, :line2, :string
    remove_column :driver_profiles, :state, :string
    remove_column :driver_profiles, :area, :string
    remove_column :driver_profiles, :company_name, :string
    remove_column :driver_profiles, :pay_unit_time_preference, :string
    remove_column :driver_profiles, :pay_rate, :float
    remove_column :driver_profiles, :lat, :decimal
    remove_column :driver_profiles, :lng, :decimal
    remove_column :driver_profiles, :job_markets, :citext
    remove_column :driver_profiles, :technical_skill_tags, :citext
    remove_column :driver_profiles, :job_functions, :citext
    remove_column :driver_profiles, :manufacturer_tags, :citext
    remove_column :driver_profiles, :valid_driver, :boolean
    remove_column :driver_profiles, :own_tools, :boolean

    # Add driver columns
    add_column :driver_profiles, :license_class, :string
    add_column :driver_profiles, :county, :string
    add_column :driver_profiles, :province, :string
    add_column :driver_profiles, :transmission_and_speed, :citext
    add_column :driver_profiles, :freight_type, :citext
    add_column :driver_profiles, :other_skills, :citext
    add_column :driver_profiles, :vehicle_type, :citext
    add_column :driver_profiles, :truck_type, :citext
    add_column :driver_profiles, :trailer_type, :citext
  end
end
