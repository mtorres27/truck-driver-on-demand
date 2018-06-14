class RemoveDeviseFromFreelancers < ActiveRecord::Migration[5.1]
  def up
    add_column :freelancers, :freelancer_id, :integer
    add_index :freelancers, :freelancer_id

    remove_foreign_key :applicants, column: :freelancer_id
    remove_foreign_key :company_reviews, column: :freelancer_id
    remove_foreign_key :freelancer_reviews, column: :freelancer_id

    rename_table :freelancers, :freelancer_profiles

    execute('select * from freelancer_profiles').each do |freelancer|
      begin
        if User.find_by(email: freelancer['email']).nil?
          user = User.new(
            email: freelancer['email'],
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
            type: 'Freelancer',
            first_name: freelancer['name']&.split(' ')&.first,
            last_name: freelancer['name']&.split(' ')&.last,
          )
          user.save(validate: false)
          execute "update freelancer_profiles set freelancer_id = #{user.id} where id = #{freelancer['id']}"

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

    Freelancer.find_each do |freelancer|
      begin
        execute "update freelancer_profiles set email = '#{freelancer.email}', encrypted_password = '#{freelancer.encrypted_password}', "\
        "name = '#{freelancer.first_name} #{freelancer.last_name}', "\
        "reset_password_token = #{value_or_default(freelancer, :reset_password_token)}, "\
        "reset_password_sent_at = #{value_or_default(freelancer, :reset_password_sent_at)}, "\
        "remember_created_at = #{value_or_default(freelancer, :remember_created_at)}, "\
        "sign_in_count = #{value_or_default(freelancer, :sign_in_count, default: 0)}, "\
        "current_sign_in_at = #{value_or_default(freelancer, :current_sign_in_at)}, "\
        "last_sign_in_at = #{value_or_default(freelancer, :last_sign_in_at)}, "\
        "current_sign_in_ip = #{value_or_default(freelancer, :current_sign_in_ip)}, "\
        "last_sign_in_ip = #{value_or_default(freelancer, :last_sign_in_ip)}, "\
        "confirmation_token = '#{freelancer.confirmation_token}', "\
        "confirmed_at = #{value_or_default(freelancer, :confirmed_at)}, "\
        "confirmation_sent_at = #{value_or_default(freelancer, :confirmation_sent_at)} "\
        "where id = #{freelancer.freelancer_profile.id}"

        freelancer.delete

        update_table_freelancer_id(Applicant, freelancer.id, freelancer.freelancer_profile.id)
        update_table_freelancer_id(CompanyReview, freelancer.id, freelancer.freelancer_profile.id)
        update_table_freelancer_id(FreelancerReview, freelancer.id, freelancer.freelancer_profile.id)
        update_table_freelancer_id(Certification, freelancer.id, freelancer.freelancer_profile.id)
        update_table_freelancer_id(FreelancerAffiliation, freelancer.id, freelancer.freelancer_profile.id)
        update_table_freelancer_id(FreelancerClearance, freelancer.id, freelancer.freelancer_profile.id)
        update_table_freelancer_id(FreelancerPortfolio, freelancer.id, freelancer.freelancer_profile.id)
        update_table_freelancer_id(FreelancerInsurance, freelancer.id, freelancer.freelancer_profile.id)
        update_table_freelancer_id(FriendInvite, freelancer.id, freelancer.freelancer_profile.id)
        update_table_freelancer_id(JobFavourite, freelancer.id, freelancer.freelancer_profile.id)
        update_table_freelancer_id(CompanyFavourite, freelancer.id, freelancer.freelancer_profile.id)
        update_messages_freelancer_id(freelancer.id, freelancer.freelancer_profile.id)
      end
    end

    rename_table :freelancer_profiles, :freelancers

    change_column :freelancers, :email, :citext, null: false
    change_column :freelancers, :encrypted_password, :string, null: false, default: ""
    change_column :freelancers, :sign_in_count, :integer, null: false

    remove_column :freelancers, :freelancer_id, :integer

    add_foreign_key :applicants, :freelancers, column: :freelancer_id
    add_foreign_key :company_reviews, :freelancers, column: :freelancer_id
    add_foreign_key :freelancer_reviews, :freelancers, column: :freelancer_id
  end

  def update_table_freelancer_id(table, old_id, new_id)
    table.where(freelancer_id: old_id).find_each do |record|
      record.update_attribute(:freelancer_id, new_id)
    end
  end

  def update_messages_freelancer_id(old_id, new_id)
    Message.where(authorable_type: 'Freelancer', authorable_id: old_id).find_each do |message|
      message.update_attribute(:authorable_id, new_id)
    end
    Message.where(receivable_type: 'Freelancer', receivable_id: old_id).find_each do |message|
      message.update_attribute(:receivable_id, new_id)
    end
  end

  def value_or_default(record, field, default: "NULL")
    record.send(field).present? ? "'#{record.send(field)}'" : default
  end
end

