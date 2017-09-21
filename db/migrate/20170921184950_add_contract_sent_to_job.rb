class AddContractSentToJob < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :contract_sent, :boolean, default: false
  end
end
