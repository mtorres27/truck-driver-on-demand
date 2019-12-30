# frozen_string_literal: true

class RemoveDeviseFromAdmins < ActiveRecord::Migration[5.1]
  def self.up
    drop_table :admin_users
  end

  def self.down
    create_table :admin_users do |t|
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

    add_index :admin_users, :email,                unique: true
    add_index :admin_users, :reset_password_token, unique: true

    change_column :admin_users, :email, :citext, null: false
    change_column :admin_users, :encrypted_password, :string, null: false, default: ""
    change_column :admin_users, :sign_in_count, :integer, null: false
  end
end
