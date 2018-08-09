class AddStripeFieldsToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :stripe_charge_id, :string
    add_column :payments, :stripe_balance_transaction_id, :string
    add_column :payments, :funds_available_on, :integer
    add_column :payments, :funds_available, :boolean, default: false
  end
end
