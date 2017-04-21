class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.string :tagline
      t.string :address
      t.text :logo_data

      t.timestamps
    end
  end
end
