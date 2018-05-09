class RemoveDeviseFromAdmins < ActiveRecord::Migration[5.1]
  def self.up
    Admin.all.each do |admin|
      begin
        user = User.new(email: admin.email,
                 encrypted_password: admin.encrypted_password,
                 reset_password_token: admin.reset_password_token,
                 reset_password_sent_at: admin.reset_password_sent_at,
                 remember_created_at: admin.remember_created_at,
                 sign_in_count: admin.sign_in_count,
                 current_sign_in_at: admin.current_sign_in_at,
                 last_sign_in_at: admin.last_sign_in_at,
                 current_sign_in_ip: admin.current_sign_in_ip,
                 last_sign_in_ip: admin.last_sign_in_ip,
                 meta: admin)
        user.save(validate: false)
      rescue Exception => e
        puts e
        logger.error e
        return false
      end
    end

    remove_column :admins, :email, :citext
    remove_column :admins, :encrypted_password, :string
    remove_column :admins, :reset_password_token, :string
    remove_column :admins, :reset_password_sent_at, :datetime
    remove_column :admins, :remember_created_at, :datetime
    remove_column :admins, :sign_in_count, :integer
    remove_column :admins, :current_sign_in_at, :datetime
    remove_column :admins, :last_sign_in_at, :datetime
    remove_column :admins, :current_sign_in_ip, :inet
    remove_column :admins, :last_sign_in_ip, :inet
  end

  def self.down
    add_column :admins, :email, :citext, null: false
    add_column :admins, :encrypted_password, :string, null: false, default: ""
    add_column :admins, :reset_password_token, :string
    add_column :admins, :reset_password_sent_at, :datetime
    add_column :admins, :remember_created_at, :datetime
    add_column :admins, :sign_in_count, :integer, null: false
    add_column :admins, :current_sign_in_at, :datetime
    add_column :admins, :last_sign_in_at, :datetime
    add_column :admins, :current_sign_in_ip, :inet
    add_column :admins, :last_sign_in_ip, :inet

    add_index :admins, :email,                unique: true
    add_index :admins, :reset_password_token, unique: true

    User.where(meta_type: 'Admin').each do |user|
      begin
        admin = user.meta
        admin.update_attributes(email: user.email,
                                encrypted_password: user.encrypted_password,
                                reset_password_token: user.reset_password_token,
                                reset_password_sent_at: user.reset_password_sent_at,
                                remember_created_at: user.remember_created_at,
                                sign_in_count: user.sign_in_count,
                                current_sign_in_at: user.current_sign_in_at,
                                last_sign_in_at: user.last_sign_in_at,
                                current_sign_in_ip: user.current_sign_in_ip,
                                last_sign_in_ip: user.last_sign_in_ip)
      rescue Exception => e
      end
    end
  end
end

