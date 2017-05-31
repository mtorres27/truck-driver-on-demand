class CreateAdmins < ActiveRecord::Migration[5.1]
  def change
    create_table :admins do |t|
      t.string :token
      t.string :email, null: false, index: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
