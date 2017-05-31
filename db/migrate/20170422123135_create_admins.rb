class CreateAdmins < ActiveRecord::Migration[5.1]
  def change
    create_table :admins do |t|
      t.string :token
      t.citext :email, null: false
      t.string :name, null: false

      t.timestamps
    end
    add_index :admins, :email, unique: true
  end
end
