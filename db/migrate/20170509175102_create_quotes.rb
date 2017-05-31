class CreateQuotes < ActiveRecord::Migration[5.1]
  def change
    create_table :quotes do |t|
      t.references :applicant, foreign_key: true, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :pay_type, null: false, default: "fixed"
      t.boolean :declined, null: false, default: false
      t.text :body
      t.text :attachment_data

      t.timestamps
    end
  end
end
