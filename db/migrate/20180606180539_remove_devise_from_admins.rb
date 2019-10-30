# frozen_string_literal: true

class RemoveDeviseFromAdmins < ActiveRecord::Migration[5.1]
  def self.up
    drop_table :admins
  end

  def self.down
    create_table :admins do |t|
      t.citext :email
      t.string :encrypted_password
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer :sign_in_count
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet :current_sign_in_ip
      t.inet :last_sign_in_ip
    end

    add_index :admins, :email,                unique: true
    add_index :admins, :reset_password_token, unique: true

    change_column :admins, :email, :citext, null: false
    change_column :admins, :encrypted_password, :string, null: false, default: ""
    change_column :admins, :sign_in_count, :integer, null: false
  end
end
