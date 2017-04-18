class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.string :street1, null: false
      t.string :street2
      t.string :city, null: false
      t.string :state, null: false
      t.string :country, null: false
      t.string :zip, null: false
      t.decimal :latitude, precision: 9, scale: 6
      t.decimal :longitude, precision: 9, scale: 6
      t.string :pay_unit_time_preference
      t.integer :pay_per_unit_time
      t.string :tagline, null: false
      t.text :bio
      t.string :markets
      t.string :skills
      t.integer :years_of_experience, null: false, default: 0
      t.integer :profile_views, null: false, default: 0
      t.integer :projects_completed, null: false, default: 0

      t.timestamps
    end
  end
end
