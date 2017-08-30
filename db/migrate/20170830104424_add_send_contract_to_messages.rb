class AddSendContractToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :send_contract, :boolean, default: false
    remove_column :messages, :counter_offer
  end
end
