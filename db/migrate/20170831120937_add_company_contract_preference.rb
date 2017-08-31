class AddCompanyContractPreference < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, 'contract_preference', :string, default: :no_preference
  end
end
