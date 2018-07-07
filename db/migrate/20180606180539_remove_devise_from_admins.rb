class RemoveDeviseFromAdmins < ActiveRecord::Migration[5.1]
  def self.up
    execute('select * from admins').each do |admin|
      begin
        if User.find_by(email: admin['email']).nil?
          user = User.new(
            email: admin['email'],
            encrypted_password: admin['encrypted_password'],
            reset_password_token: admin['reset_password_token'],
            reset_password_sent_at: admin['reset_password_sent_at'],
            remember_created_at: admin['remember_created_at'],
            sign_in_count: admin['sign_in_count'],
            current_sign_in_at: admin['current_sign_in_at'],
            last_sign_in_at: admin['last_sign_in_at'],
            current_sign_in_ip: admin['current_sign_in_ip'],
            last_sign_in_ip: admin['last_sign_in_ip'],
            type: 'Admin',
            confirmed_at: Time.current,
          )
          user.save(validate: false)
        end
      end
    end

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

    Admin.all.each do |admin|
      begin
        execute "insert into admins (email, encrypted_password, reset_password_token, reset_password_sent_at, "\
        "remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip) "\
        "values ('#{admin.email}', '#{admin.encrypted_password}', '#{admin.reset_password_token}', "\
        "#{admin.reset_password_sent_at.present? ? "'#{admin.reset_password_sent_at}'" : "NULL"}, "\
        "#{admin.remember_created_at.present? ? "'#{admin.remember_created_at}'" : "NULL"}, "\
        "#{admin.sign_in_count || 0}, #{admin.current_sign_in_at.present? ? "'#{admin.current_sign_in_at}'" : "NULL"}, "\
        "#{admin.last_sign_in_at.present? ? "'#{admin.last_sign_in_at}'" : "NULL"}, "\
        "#{admin.current_sign_in_ip.present? ? "'#{admin.current_sign_in_ip}'" : "NULL"}, "\
        "#{admin.last_sign_in_ip.present? ? "'#{admin.last_sign_in_ip}'" : "NULL"})"
        admin.destroy!
      end
    end

    change_column :admins, :email, :citext, null: false
    change_column :admins, :encrypted_password, :string, null: false, default: ""
    change_column :admins, :sign_in_count, :integer, null: false
  end
end

