# frozen_string_literal: true

class AddCalculationsFieldsToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :company_fees, :decimal, precision: 10, scale: 2, default: 0
    add_column :payments, :total_company_fees, :decimal, precision: 10, scale: 2, default: 0
    add_column :payments, :freelancer_fees, :decimal, precision: 10, scale: 2, default: 0
    add_column :payments, :total_freelancer_fees, :decimal, precision: 10, scale: 2, default: 0
    add_column :payments, :transaction_fees, :decimal, precision: 10, scale: 2, default: 0
  end
end
