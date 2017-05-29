class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :token, null: false
      t.string :email, null: false, index: true
      t.string :name, null: false, index: true
      t.string :contact_name, null: false
      t.string :currency, null: false, default: "CAD"
      t.string :address
      t.string :formatted_address
      t.string :area
      t.decimal :lat, precision: 9, scale: 6
      t.decimal :lng, precision: 9, scale: 6
      t.string :hq_country
      t.string :description
      t.text :avatar_data
      t.boolean :disabled, null: false, default: false, index: true

      t.timestamps
    end
  end
end
