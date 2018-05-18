class RemoveDeviseFromFreelancers < ActiveRecord::Migration[5.1]
  def self.up
    Freelancer.all.each do |freelancer|
      begin
        if User.where(email: freelancer.email).count.zero?
          user = User.new(email: freelancer.email,
                          encrypted_password: freelancer.encrypted_password,
                          reset_password_token: freelancer.reset_password_token,
                          reset_password_sent_at: freelancer.reset_password_sent_at,
                          remember_created_at: freelancer.remember_created_at,
                          sign_in_count: freelancer.sign_in_count,
                          current_sign_in_at: freelancer.current_sign_in_at,
                          last_sign_in_at: freelancer.last_sign_in_at,
                          current_sign_in_ip: freelancer.current_sign_in_ip,
                          last_sign_in_ip: freelancer.last_sign_in_ip,
                          confirmation_token: freelancer.confirmation_token,
                          confirmed_at: freelancer.confirmed_at,
                          confirmation_sent_at: freelancer.confirmation_sent_at,
                          meta: freelancer)
          user.save(validate: false)
        end
      rescue Exception => e
        puts e
        logger.error e
        return false
      end
    end

    remove_column :freelancers, :email, :citext
    remove_column :freelancers, :encrypted_password, :string
    remove_column :freelancers, :reset_password_token, :string
    remove_column :freelancers, :reset_password_sent_at, :datetime
    remove_column :freelancers, :remember_created_at, :datetime
    remove_column :freelancers, :sign_in_count, :integer
    remove_column :freelancers, :current_sign_in_at, :datetime
    remove_column :freelancers, :last_sign_in_at, :datetime
    remove_column :freelancers, :current_sign_in_ip, :inet
    remove_column :freelancers, :last_sign_in_ip, :inet
    remove_column :freelancers, :confirmation_token, :string
    remove_column :freelancers, :confirmed_at, :datetime
    remove_column :freelancers, :confirmation_sent_at, :datetime
  end

  def self.down
    add_column :freelancers, :email, :citext
    add_column :freelancers, :encrypted_password, :string
    add_column :freelancers, :reset_password_token, :string
    add_column :freelancers, :reset_password_sent_at, :datetime
    add_column :freelancers, :remember_created_at, :datetime
    add_column :freelancers, :sign_in_count, :integer
    add_column :freelancers, :current_sign_in_at, :datetime
    add_column :freelancers, :last_sign_in_at, :datetime
    add_column :freelancers, :current_sign_in_ip, :inet
    add_column :freelancers, :last_sign_in_ip, :inet
    add_column :freelancers, :confirmation_token, :string
    add_column :freelancers, :confirmed_at, :datetime
    add_column :freelancers, :confirmation_sent_at, :datetime

    add_index :freelancers, :confirmation_token, unique: true
    add_index :freelancers, :email,                unique: true
    add_index :freelancers, :reset_password_token, unique: true

    Freelancer.all.update_all confirmed_at: DateTime.now

    User.where(meta_type: 'Freelancer').each do |user|
      begin
        freelancer = user.meta
        freelancer.update_attributes(email: user.email,
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

    change_column :freelancers, :email, :citext, null: false
    change_column :freelancers, :encrypted_password, :string, null: false, default: ""
    change_column :freelancers, :sign_in_count, :integer, null: false
  end
end
