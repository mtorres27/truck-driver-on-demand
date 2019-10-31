# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.references :authorable, polymorphic: true, null: false, index: true
      t.references :receivable, polymorphic: true, null: false, index: true
      t.text :body
      t.text :title
      t.datetime :read_at
      t.text :url
      t.timestamps
    end
  end
end
