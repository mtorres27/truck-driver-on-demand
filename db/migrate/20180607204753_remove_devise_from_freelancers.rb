class RemoveDeviseFromFreelancers < ActiveRecord::Migration[5.1]
  def up
    add_column :freelancers, :freelancer_id, :integer
    add_index :freelancers, :freelancer_id

    remove_foreign_key :applicants, column: :freelancer_id
    remove_foreign_key :company_reviews, column: :freelancer_id
    remove_foreign_key :freelancer_reviews, column: :freelancer_id

    rename_table :freelancers, :freelancer_profiles

    remove_column :freelancer_profiles, :name, :string
    remove_column :freelancer_profiles, :email, :citext
    remove_column :freelancer_profiles, :encrypted_password, :string
    remove_column :freelancer_profiles, :reset_password_token, :string
    remove_column :freelancer_profiles, :reset_password_sent_at, :datetime
    remove_column :freelancer_profiles, :remember_created_at, :datetime
    remove_column :freelancer_profiles, :sign_in_count, :integer
    remove_column :freelancer_profiles, :current_sign_in_at, :datetime
    remove_column :freelancer_profiles, :last_sign_in_at, :datetime
    remove_column :freelancer_profiles, :current_sign_in_ip, :inet
    remove_column :freelancer_profiles, :last_sign_in_ip, :inet
    remove_column :freelancer_profiles, :confirmation_token, :string
    remove_column :freelancer_profiles, :confirmed_at, :datetime
    remove_column :freelancer_profiles, :confirmation_sent_at, :datetime
    remove_column :freelancer_profiles, :messages_count, :integer

    add_foreign_key :applicants, :users, column: :freelancer_id
    add_foreign_key :company_reviews, :users, column: :freelancer_id
    add_foreign_key :freelancer_reviews, :users, column: :freelancer_id
  end

  def down
    add_column :freelancer_profiles, :name, :string
    add_column :freelancer_profiles, :email, :citext
    add_column :freelancer_profiles, :encrypted_password, :string
    add_column :freelancer_profiles, :reset_password_token, :string
    add_column :freelancer_profiles, :reset_password_sent_at, :datetime
    add_column :freelancer_profiles, :remember_created_at, :datetime
    add_column :freelancer_profiles, :sign_in_count, :integer
    add_column :freelancer_profiles, :current_sign_in_at, :datetime
    add_column :freelancer_profiles, :last_sign_in_at, :datetime
    add_column :freelancer_profiles, :current_sign_in_ip, :inet
    add_column :freelancer_profiles, :last_sign_in_ip, :inet
    add_column :freelancer_profiles, :confirmation_token, :string
    add_column :freelancer_profiles, :confirmed_at, :datetime
    add_column :freelancer_profiles, :confirmation_sent_at, :datetime
    add_column :freelancer_profiles, :messages_count, :integer, null: false, default: 0

    add_index :freelancer_profiles, :email,                unique: true
    add_index :freelancer_profiles, :reset_password_token, unique: true

    remove_foreign_key :applicants, column: :freelancer_id
    remove_foreign_key :company_reviews, column: :freelancer_id
    remove_foreign_key :freelancer_reviews, column: :freelancer_id

    rename_table :freelancer_profiles, :freelancers

    change_column :freelancers, :email, :citext, null: false
    change_column :freelancers, :encrypted_password, :string, null: false, default: ""
    change_column :freelancers, :sign_in_count, :integer, null: false

    remove_column :freelancers, :freelancer_id, :integer

    add_foreign_key :applicants, :freelancers, column: :freelancer_id
    add_foreign_key :company_reviews, :freelancers, column: :freelancer_id
    add_foreign_key :freelancer_reviews, :freelancers, column: :freelancer_id
  end
end

