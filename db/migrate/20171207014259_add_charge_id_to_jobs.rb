# frozen_string_literal: true

class AddChargeIdToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :stripe_charge_id, :string
    add_column :jobs, :stripe_balance_transaction_id, :string
    add_column :jobs, :funds_available_on, :integer
    add_column :jobs, :funds_available, :boolean, default: false
  end
end
