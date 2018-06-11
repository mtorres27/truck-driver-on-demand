class RemoveDeviseFromCompanies < ActiveRecord::Migration[5.1]
  def self.up
    add_column :companies, :company_id, :integer
    add_index :companies, :company_id

    remove_foreign_key :projects, column: :company_id
    remove_foreign_key :jobs, column: :company_id
    remove_foreign_key :applicants, column: :company_id
    remove_foreign_key :quotes, column: :company_id
    remove_foreign_key :payments, column: :company_id
    remove_foreign_key :change_orders, column: :company_id
    remove_foreign_key :company_reviews, column: :company_id
    remove_foreign_key :freelancer_reviews, column: :company_id

    execute('select * from companies').each do |company|
      begin
        if User.where(email: company['email']).count.zero?
          user = User.new(email: company['email'],
                          encrypted_password: company['encrypted_password'],
                          reset_password_token: company['reset_password_token'],
                          reset_password_sent_at: company['reset_password_sent_at'],
                          remember_created_at: company['remember_created_at'],
                          sign_in_count: company['sign_in_count'],
                          current_sign_in_at: company['current_sign_in_at'],
                          last_sign_in_at: company['last_sign_in_at'],
                          current_sign_in_ip: company['current_sign_in_ip'],
                          last_sign_in_ip: company['last_sign_in_ip'],
                          confirmation_token: company['confirmation_token'],
                          confirmed_at: company['confirmed_at'],
                          confirmation_sent_at: company['confirmation_sent_at'],
                          type: 'Company'
          )
          user.save(validate: false)
          execute "update companies set company_id = #{user.id} where id = #{company['id']}"

          update_table_company_id(Applicant, company['id'], user.id)
          update_table_company_id(ChangeOrder, company['id'], user.id)
          update_table_company_id(CompanyFavourite, company['id'], user.id)
          update_table_company_id(CompanyReview, company['id'], user.id)
          update_table_company_id(FreelancerReview, company['id'], user.id)
          update_table_company_id(Favourite, company['id'], user.id)
          update_table_company_id(FeaturedProject, company['id'], user.id)
          update_table_company_id(Job, company['id'], user.id)
          update_table_company_id(Payment, company['id'], user.id)
          update_table_company_id(Project, company['id'], user.id)
          update_table_company_id(Quote, company['id'], user.id)
          update_table_company_id(CompanyInstall, company['id'], user.id)
          update_messages_company_id(company['id'], user.id)
        end
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
    remove_column :companies, :messages_count, :integer

    rename_table :companies, :company_datas

    add_foreign_key :projects, :users, column: :company_id
    add_foreign_key :jobs, :users, column: :company_id
    add_foreign_key :applicants, :users, column: :company_id
    add_foreign_key :quotes, :users, column: :company_id
    add_foreign_key :payments, :users, column: :company_id
    add_foreign_key :change_orders, :users, column: :company_id
    add_foreign_key :company_reviews, :users, column: :company_id
    add_foreign_key :freelancer_reviews, :users, column: :company_id
  end

  def self.down
    add_column :company_datas, :email, :citext
    add_column :company_datas, :encrypted_password, :string
    add_column :company_datas, :reset_password_token, :string
    add_column :company_datas, :reset_password_sent_at, :datetime
    add_column :company_datas, :remember_created_at, :datetime
    add_column :company_datas, :sign_in_count, :integer
    add_column :company_datas, :current_sign_in_at, :datetime
    add_column :company_datas, :last_sign_in_at, :datetime
    add_column :company_datas, :current_sign_in_ip, :inet
    add_column :company_datas, :last_sign_in_ip, :inet
    add_column :company_datas, :confirmation_token, :string
    add_column :company_datas, :confirmed_at, :datetime
    add_column :company_datas, :confirmation_sent_at, :datetime
    add_column :company_datas, :messages_count, :integer, null: false, default: 0

    add_index :company_datas, :email,                unique: true
    add_index :company_datas, :reset_password_token, unique: true

    remove_foreign_key :projects, column: :company_id
    remove_foreign_key :jobs, column: :company_id
    remove_foreign_key :applicants, column: :company_id
    remove_foreign_key :quotes, column: :company_id
    remove_foreign_key :payments, column: :company_id
    remove_foreign_key :change_orders, column: :company_id
    remove_foreign_key :company_reviews, column: :company_id
    remove_foreign_key :freelancer_reviews, column: :company_id

    Company.all.each do |company|
      begin
        execute "update company_datas set email = '#{company.email}', encrypted_password = '#{company.encrypted_password}', "\
        "reset_password_token = #{company.reset_password_token.present? ? "'#{company.reset_password_token}'" : "NULL"}, "\
        "reset_password_sent_at = #{company.reset_password_sent_at.present? ? "'#{company.reset_password_sent_at}'" : "NULL"}, "\
        "remember_created_at = #{company.remember_created_at.present? ? "'#{company.remember_created_at}'" : "NULL"}, "\
        "sign_in_count = #{company.sign_in_count || 0}, "\
        "current_sign_in_at = #{company.current_sign_in_at.present? ? "'#{company.current_sign_in_at}'" : "NULL"}, "\
        "last_sign_in_at = #{company.last_sign_in_at.present? ? "'#{company.last_sign_in_at}'" : "NULL"}, "\
        "current_sign_in_ip = #{company.current_sign_in_ip.present? ? "'#{company.current_sign_in_ip}'" : "NULL"}, "\
        "last_sign_in_ip = #{company.last_sign_in_ip.present? ? "'#{company.last_sign_in_ip}'" : "NULL"}, "\
        "confirmation_token = '#{company.confirmation_token}', "\
        "confirmed_at = #{company.confirmed_at.present? ? "'#{company.confirmed_at}'" : "NULL"}, "\
        "confirmation_sent_at = #{company.confirmation_sent_at.present? ? "'#{company.confirmation_sent_at}'" : "NULL"} "\
        "where id = #{company.company_data.id}"

        company.delete

        update_table_company_id(Applicant, company.id, company.company_data.id)
        update_table_company_id(ChangeOrder, company.id, company.company_data.id)
        update_table_company_id(CompanyFavourite, company.id, company.company_data.id)
        update_table_company_id(CompanyReview, company.id, company.company_data.id)
        update_table_company_id(FreelancerReview, company.id, company.company_data.id)
        update_table_company_id(Favourite, company.id, company.company_data.id)
        update_table_company_id(FeaturedProject, company.id, company.company_data.id)
        update_table_company_id(Job, company.id, company.company_data.id)
        update_table_company_id(Payment, company.id, company.company_data.id)
        update_table_company_id(Project, company.id, company.company_data.id)
        update_table_company_id(Quote, company.id, company.company_data.id)
        update_table_company_id(CompanyInstall, company.id, company.company_data.id)
        update_messages_company_id(company.id, company.company_data.id)
      end
    end

    rename_table :company_datas, :companies

    change_column :companies, :email, :citext, null: false
    change_column :companies, :encrypted_password, :string, null: false, default: ""
    change_column :companies, :sign_in_count, :integer, null: false

    remove_column :companies, :company_id, :integer

    add_foreign_key :projects, :companies, column: :company_id
    add_foreign_key :jobs, :companies, column: :company_id
    add_foreign_key :applicants, :companies, column: :company_id
    add_foreign_key :quotes, :companies, column: :company_id
    add_foreign_key :payments, :companies, column: :company_id
    add_foreign_key :change_orders, :companies, column: :company_id
    add_foreign_key :company_reviews, :companies, column: :company_id
    add_foreign_key :freelancer_reviews, :companies, column: :company_id
  end

  def update_table_company_id(table, old_id, new_id)
    table.where(company_id: old_id).each do |record|
      record.update_attribute(:company_id, new_id)
    end
  end

  def update_messages_company_id(old_id, new_id)
    Message.where(authorable_type: 'Company', authorable_id: old_id).each do |message|
      message.update_attribute(:authorable_id, new_id)
    end
    Message.where(receivable_type: 'Company', receivable_id: old_id).each do |message|
      message.update_attribute(:receivable_id, new_id)
    end
  end
end
