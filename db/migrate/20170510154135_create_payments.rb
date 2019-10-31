# frozen_string_literal: true

class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.references :company, foreign_key: true, null: false, index: true
      t.references :job, foreign_key: true, null: false, index: true
      t.string :description, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.date :issued_on
      t.date :paid_on
      t.text :attachment_data

      t.timestamps
    end
  end
end
