# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.references :authorable, polymorphic: true, null: false, index: true
      t.references :receivable, polymorphic: true, null: false, index: true
      t.text :body
      t.text :attachment_data

      t.timestamps
    end
  end
end
