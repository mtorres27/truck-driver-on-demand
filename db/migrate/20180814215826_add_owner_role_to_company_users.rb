class AddOwnerRoleToCompanyUsers < ActiveRecord::Migration[5.1]
  def up
    Company.find_each do |company|
      company.company_users.first.add_valid_role :owner if company.owner.nil?
    end
  end

  def down
  #   Nothing to do here
  end
end
