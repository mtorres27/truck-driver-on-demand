class CreateQuotes < ActiveRecord::Migration[5.1]
  def change
    create_table :quotes do |t|
      t.references :company, foreign_key: true, null: false, index: true
      t.references :applicant, foreign_key: true, null: false
      t.string :state, null: false, default: "pending"
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :pay_type, null: false, default: "fixed"
      t.text :attachment_data

      t.timestamps
    end
  end
end
