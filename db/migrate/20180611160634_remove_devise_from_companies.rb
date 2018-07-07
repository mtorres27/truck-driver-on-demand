class RemoveDeviseFromCompanies < ActiveRecord::Migration[5.1]
  def up
    ActiveRecord::Base.transaction do
      execute('select * from companies').each do |company|
        next if User.find_by(email: company['email']).present?

        user = User.new(
          email: company['email'],
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
          first_name: company['contact_name'].split(" ").first,
          last_name: company['contact_name'].split(" ").last,
          type: 'CompanyUser',
          company_id: company['id'],
        )
        user.save(validate: false)
      end
    end

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

    CompanyUser.find_each do |user|
      begin
        execute "update companies set email = '#{user.email}', encrypted_password = '#{user.encrypted_password}', "\
        "contact_name = '#{user.first_name} #{user.last_name}', "\
        "reset_password_token = #{value_or_default(user, :reset_password_token)}, "\
        "reset_password_sent_at = #{value_or_default(user, :reset_password_sent_at)}, "\
        "remember_created_at = #{value_or_default(user, :remember_created_at)}, "\
        "sign_in_count = #{value_or_default(user, :sign_in_count, default: 0)}, "\
        "current_sign_in_at = #{value_or_default(user, :current_sign_in_at)}, "\
        "last_sign_in_at = #{value_or_default(user, :last_sign_in_at)}, "\
        "current_sign_in_ip = #{value_or_default(user, :current_sign_in_ip)}, "\
        "last_sign_in_ip = #{value_or_default(user, :last_sign_in_ip)}, "\
        "confirmation_token = '#{user.confirmation_token}', "\
        "confirmed_at = #{value_or_default(user, :confirmed_at)}, "\
        "confirmation_sent_at = #{value_or_default(user, :confirmation_sent_at)} "\
        "where id = #{user.company_id}"

        user.delete
      end
    end

    change_column :companies, :email, :citext, null: false
    change_column :companies, :encrypted_password, :string, null: false, default: ""
    change_column :companies, :sign_in_count, :integer, null: false
  end

  def value_or_default(record, field, default: "NULL")
    record.send(field).present? ? "'#{record.send(field)}'" : default
  end
end
