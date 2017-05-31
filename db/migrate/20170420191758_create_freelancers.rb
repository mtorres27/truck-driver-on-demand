class CreateFreelancers < ActiveRecord::Migration[5.1]
  def change
    create_table :freelancers do |t|
      t.string :token
      t.string :email, null: false, index: true
      t.string :name, null: false, index: true
      t.text :avatar_data
      t.string :address
      t.string :formatted_address
      t.string :area, index: true
      t.decimal :lat, precision: 9, scale: 6
      t.decimal :lng, precision: 9, scale: 6
      t.string :pay_unit_time_preference
      t.integer :pay_per_unit_time
      t.string :tagline
      t.text :bio
      t.string :keywords, index: true
      t.integer :years_of_experience, null: false, default: 0
      t.integer :profile_views, null: false, default: 0
      t.integer :projects_completed, null: false, default: 0
      t.boolean :available, null: false, default: true, index: true
      t.boolean :disabled, null: false, default: false, index: true

      t.timestamps
    end
  end
end
