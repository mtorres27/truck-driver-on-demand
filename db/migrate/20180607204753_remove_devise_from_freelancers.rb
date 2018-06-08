class RemoveDeviseFromFreelancers < ActiveRecord::Migration[5.1]
  def self.up
    add_column :freelancers, :freelancer_id, :integer
    add_index :freelancers, :freelancer_id

    remove_foreign_key :applicants, column: :freelancer_id
    remove_foreign_key :company_reviews, column: :freelancer_id
    remove_foreign_key :freelancer_reviews, column: :freelancer_id

    execute('select * from freelancers').each do |freelancer|
      begin
        if User.where(email: freelancer['email']).count.zero?
          user = User.new(email: freelancer['email'],
                          encrypted_password: freelancer['encrypted_password'],
                          reset_password_token: freelancer['reset_password_token'],
                          reset_password_sent_at: freelancer['reset_password_sent_at'],
                          remember_created_at: freelancer['remember_created_at'],
                          sign_in_count: freelancer['sign_in_count'],
                          current_sign_in_at: freelancer['current_sign_in_at'],
                          last_sign_in_at: freelancer['last_sign_in_at'],
                          current_sign_in_ip: freelancer['current_sign_in_ip'],
                          last_sign_in_ip: freelancer['last_sign_in_ip'],
                          confirmation_token: freelancer['confirmation_token'],
                          confirmed_at: freelancer['confirmed_at'],
                          confirmation_sent_at: freelancer['confirmation_sent_at'],
                          type: 'Freelancer'
          )
          user.save(validate: false)
          execute "update freelancers set freelancer_id = #{user.id} where id = #{freelancer['id']}"

          update_table_freelancer_id(Applicant, freelancer['id'], user.id)
          update_table_freelancer_id(CompanyReview, freelancer['id'], user.id)
          update_table_freelancer_id(FreelancerReview, freelancer['id'], user.id)
          update_table_freelancer_id(Certification, freelancer['id'], user.id)
          update_table_freelancer_id(FreelancerAffiliation, freelancer['id'], user.id)
          update_table_freelancer_id(FreelancerClearance, freelancer['id'], user.id)
          update_table_freelancer_id(FreelancerPortfolio, freelancer['id'], user.id)
          update_table_freelancer_id(FreelancerInsurance, freelancer['id'], user.id)
          update_table_freelancer_id(FriendInvite, freelancer['id'], user.id)
          update_table_freelancer_id(JobFavourite, freelancer['id'], user.id)
          update_table_freelancer_id(CompanyFavourite, freelancer['id'], user.id)
          update_messages_freelancer_id(freelancer['id'], user.id)
        end
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
    remove_column :freelancers, :messages_count, :integer

    rename_table :freelancers, :freelancer_datas

    add_foreign_key :applicants, :users, column: :freelancer_id
    add_foreign_key :company_reviews, :users, column: :freelancer_id
    add_foreign_key :freelancer_reviews, :freelancer_datas, column: :freelancer_id
  end

  def self.down
    add_column :freelancer_datas, :email, :citext
    add_column :freelancer_datas, :encrypted_password, :string
    add_column :freelancer_datas, :reset_password_token, :string
    add_column :freelancer_datas, :reset_password_sent_at, :datetime
    add_column :freelancer_datas, :remember_created_at, :datetime
    add_column :freelancer_datas, :sign_in_count, :integer
    add_column :freelancer_datas, :current_sign_in_at, :datetime
    add_column :freelancer_datas, :last_sign_in_at, :datetime
    add_column :freelancer_datas, :current_sign_in_ip, :inet
    add_column :freelancer_datas, :last_sign_in_ip, :inet
    add_column :freelancer_datas, :confirmation_token, :string
    add_column :freelancer_datas, :confirmed_at, :datetime
    add_column :freelancer_datas, :confirmation_sent_at, :datetime
    add_column :freelancer_datas, :messages_count, :integer, null: false, default: 0

    add_index :freelancer_datas, :email,                unique: true
    add_index :freelancer_datas, :reset_password_token, unique: true

    remove_foreign_key :applicants, column: :freelancer_id
    remove_foreign_key :company_reviews, column: :freelancer_id
    remove_foreign_key :freelancer_reviews, column: :freelancer_id

    Freelancer.all.each do |freelancer|
      begin
        execute "update freelancer_datas set email = '#{freelancer.email}', encrypted_password = '#{freelancer.encrypted_password}', "\
        "reset_password_token = #{freelancer.reset_password_token.present? ? "'#{freelancer.reset_password_token}'" : "NULL"}, "\
        "reset_password_sent_at = #{freelancer.reset_password_sent_at.present? ? "'#{freelancer.reset_password_sent_at}'" : "NULL"}, "\
        "remember_created_at = #{freelancer.remember_created_at.present? ? "'#{freelancer.remember_created_at}'" : "NULL"}, "\
        "sign_in_count = #{freelancer.sign_in_count || 0}, "\
        "current_sign_in_at = #{freelancer.current_sign_in_at.present? ? "'#{freelancer.current_sign_in_at}'" : "NULL"}, "\
        "last_sign_in_at = #{freelancer.last_sign_in_at.present? ? "'#{freelancer.last_sign_in_at}'" : "NULL"}, "\
        "current_sign_in_ip = #{freelancer.current_sign_in_ip.present? ? "'#{freelancer.current_sign_in_ip}'" : "NULL"}, "\
        "last_sign_in_ip = #{freelancer.last_sign_in_ip.present? ? "'#{freelancer.last_sign_in_ip}'" : "NULL"}, "\
        "confirmation_token = '#{freelancer.confirmation_token}', "\
        "confirmed_at = #{freelancer.confirmed_at.present? ? "'#{freelancer.confirmed_at}'" : "NULL"}, "\
        "confirmation_sent_at = #{freelancer.confirmation_sent_at.present? ? "'#{freelancer.confirmation_sent_at}'" : "NULL"} "\
        "where id = #{freelancer.freelancer_data.id}"

        freelancer.delete

        update_table_freelancer_id(Applicant, freelancer.id, freelancer.freelancer_data.id)
        update_table_freelancer_id(CompanyReview, freelancer.id, freelancer.freelancer_data.id)
        update_table_freelancer_id(FreelancerReview, freelancer.id, freelancer.freelancer_data.id)
        update_table_freelancer_id(Certification, freelancer.id, freelancer.freelancer_data.id)
        update_table_freelancer_id(FreelancerAffiliation, freelancer.id, freelancer.freelancer_data.id)
        update_table_freelancer_id(FreelancerClearance, freelancer.id, freelancer.freelancer_data.id)
        update_table_freelancer_id(FreelancerPortfolio, freelancer.id, freelancer.freelancer_data.id)
        update_table_freelancer_id(FreelancerInsurance, freelancer.id, freelancer.freelancer_data.id)
        update_table_freelancer_id(FriendInvite, freelancer.id, freelancer.freelancer_data.id)
        update_table_freelancer_id(JobFavourite, freelancer.id, freelancer.freelancer_data.id)
        update_table_freelancer_id(CompanyFavourite, freelancer.id, freelancer.freelancer_data.id)
        update_messages_freelancer_id(freelancer.id, freelancer.freelancer_data.id)
      end
    end

    rename_table :freelancer_datas, :freelancers

    change_column :freelancers, :email, :citext, null: false
    change_column :freelancers, :encrypted_password, :string, null: false, default: ""
    change_column :freelancers, :sign_in_count, :integer, null: false

    remove_column :freelancers, :freelancer_id, :integer

    add_foreign_key :applicants, :freelancers, column: :freelancer_id
    add_foreign_key :company_reviews, :freelancers, column: :freelancer_id
    add_foreign_key :freelancer_reviews, :freelancers, column: :freelancer_id
  end

  def update_table_freelancer_id(table, old_id, new_id)
    table.where(freelancer_id: old_id).each do |record|
      record.update_attribute(:freelancer_id, new_id)
    end
  end

  def update_messages_freelancer_id(old_id, new_id)
    Message.where(authorable_type: 'Freelancer', authorable_id: old_id).each do |message|
      message.update_attribute(:authorable_id, new_id)
    end
    Message.where(receivable_type: 'Freelancer', receivable_id: old_id).each do |message|
      message.update_attribute(:receivable_id, new_id)
    end
  end
end

