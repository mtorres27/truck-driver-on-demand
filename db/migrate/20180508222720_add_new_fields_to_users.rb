# frozen_string_literal: true

class AddNewFieldsToUsers < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      ## Confirmable
      t.string      :confirmation_token
      t.datetime    :confirmed_at
      t.datetime    :confirmation_sent_at

      t.string      :first_name
      t.string      :last_name
      t.string      :type
      t.integer     :messages_count, null: false, default: 0
      t.references  :company
    end

    add_index :users, :confirmation_token, unique: true
  end
end
