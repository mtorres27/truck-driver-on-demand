class RemoveDeviseFromCompanies < ActiveRecord::Migration[5.1]
  def self.up
    Company.all.each do |company|
      begin
        if User.where(email: company.email).count.zero?
          user = User.new(email: company.email,
                          encrypted_password: company.encrypted_password,
                          reset_password_token: company.reset_password_token,
                          reset_password_sent_at: company.reset_password_sent_at,
                          remember_created_at: company.remember_created_at,
                          sign_in_count: company.sign_in_count,
                          current_sign_in_at: company.current_sign_in_at,
                          last_sign_in_at: company.last_sign_in_at,
                          current_sign_in_ip: company.current_sign_in_ip,
                          last_sign_in_ip: company.last_sign_in_ip,
                          confirmation_token: company.confirmation_token,
                          confirmed_at: company.confirmed_at,
                          confirmation_sent_at: company.confirmation_sent_at,
                          meta: company)
          user.save(validate: false)
        end
      rescue Exception => e
        puts e
        logger.error e
        return false
      end
    end

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

  def self.down
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

    add_index :companies, :confirmation_token, unique: true
    add_index :companies, :email,                unique: true
    add_index :companies, :reset_password_token, unique: true

    Company.all.update_all confirmed_at: DateTime.now

    User.where(meta_type: 'Company').each do |user|
      begin
        company = user.meta
        company.update_attributes(email: user.email,
                                     encrypted_password: user.encrypted_password,
                                     reset_password_token: user.reset_password_token,
                                     reset_password_sent_at: user.reset_password_sent_at,
                                     remember_created_at: user.remember_created_at,
                                     sign_in_count: user.sign_in_count,
                                     current_sign_in_at: user.current_sign_in_at,
                                     last_sign_in_at: user.last_sign_in_at,
                                     current_sign_in_ip: user.current_sign_in_ip,
                                     last_sign_in_ip: user.last_sign_in_ip)
        user.destroy!
      rescue Exception => e
      end
    end

    change_column :companies, :email, :citext, null: false
    change_column :companies, :encrypted_password, :string, null: false, default: ""
    change_column :companies, :sign_in_count, :integer, null: false
  end
end
