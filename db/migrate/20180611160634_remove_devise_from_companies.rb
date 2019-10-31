# frozen_string_literal: true

class RemoveDeviseFromCompanies < ActiveRecord::Migration[5.1]
  def up
    remove_column :companies, :contact_name, :string
    remove_column :companies, :email, :citext
    remove_column :companies, :encrypted_password, :string
    remove_column :companies, :reset_password_token, :string
    remove_column :companies, :reset_password_sent_at, :datetime
    remove_column :companies, :remember_created_at, :datetime
    remove_column :companies, :sign_in_count, :integer
    remove_column :companies, :current_sign_in_at, :datetime
    remove_column :companies, :last_sign_in_at, :datetime
    remove_column :companies, :current_sign_in_ip, :inet
    remove_column :companies, :last_sign_in_ip, :inet
    remove_column :companies, :confirmation_token, :string
    remove_column :companies, :confirmed_at, :datetime
    remove_column :companies, :confirmation_sent_at, :datetime
  end

  def down
    add_column :companies, :contact_name, :string
    add_column :companies, :email, :citext
    add_column :companies, :encrypted_password, :string
    add_column :companies, :reset_password_token, :string
    add_column :companies, :reset_password_sent_at, :datetime
    add_column :companies, :remember_created_at, :datetime
    add_column :companies, :sign_in_count, :integer
    add_column :companies, :current_sign_in_at, :datetime
    add_column :companies, :last_sign_in_at, :datetime
    add_column :companies, :current_sign_in_ip, :inet
    add_column :companies, :last_sign_in_ip, :inet
    add_column :companies, :confirmation_token, :string
    add_column :companies, :confirmed_at, :datetime
    add_column :companies, :confirmation_sent_at, :datetime

    add_index :companies, :email,                unique: true
    add_index :companies, :reset_password_token, unique: true

    change_column :companies, :email, :citext, null: false
    change_column :companies, :encrypted_password, :string, null: false, default: ""
    change_column :companies, :sign_in_count, :integer, null: false
  end
end
