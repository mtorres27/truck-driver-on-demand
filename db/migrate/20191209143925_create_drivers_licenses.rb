class CreateDriversLicenses < ActiveRecord::Migration[5.1]
  def change
    remove_column :driver_profiles, :license_class, :string
    add_column :driver_profiles, :drivers_license_uploaded, :boolean, default: false

    create_table :drivers_licenses do |t|
      t.references :driver_profile, foreign_key: true, null: false, index: true
      t.text :license_data
      t.string :license_number
      t.date :exp_date
      t.string :license_class
      t.timestamps
    end
  end
end
