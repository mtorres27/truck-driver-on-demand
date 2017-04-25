class CreateFreelancers < ActiveRecord::Migration[5.1]
  def change
    create_table :freelancers do |t|
      t.string :email, null: false
      t.string :name
      t.string :address
      t.string :formatted_address
      t.string :area
      t.decimal :lat, precision: 9, scale: 6
      t.decimal :lng, precision: 9, scale: 6
      t.string :pay_unit_time_preference
      t.integer :pay_per_unit_time
      t.string :tagline
      t.text :bio
      t.string :markets
      t.string :skills
      t.integer :years_of_experience, null: false, default: 0
      t.integer :profile_views, null: false, default: 0
      t.integer :projects_completed, null: false, default: 0
      t.boolean :disabled, null: false, default: false

      t.timestamps
    end
  end
end
