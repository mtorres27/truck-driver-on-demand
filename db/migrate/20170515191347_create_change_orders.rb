class CreateChangeOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :change_orders do |t|
      t.references :job, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.text :body, null: false
      t.text :attachment_data

      t.timestamps
    end
  end
end
