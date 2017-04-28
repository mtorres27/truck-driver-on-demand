class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.references :company, foreign_key: true, index: true
      t.string :external_project_id, index: true
      t.string :name, null: false, index: true
      t.decimal :budget, precision: 10, scale: 2, null: false, index: true
      t.date :starts_on, index: true
      t.integer :duration
      t.string :address, null: false
      t.string :formatted_address
      t.string :area, index: true
      t.decimal :lat, precision: 9, scale: 6
      t.decimal :lng, precision: 9, scale: 6

      t.timestamps
    end
  end
end
