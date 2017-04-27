class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.references :company, foreign_key: true, index: true
      t.string :external_project_id, index: true
      t.string :name, null: false, index: true
      t.decimal :budget, precision: 10, scale: 2, null: false, index: true
      t.datetime :starts_on, index: true
      t.integer :duration

      t.timestamps
    end
  end
end
