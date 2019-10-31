# frozen_string_literal: true

class AddAvjFeesRateToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :freelancer_avj_fees_rate, :decimal, precision: 10, scale: 2
    add_column :payments, :company_avj_fees_rate, :decimal, precision: 10, scale: 2
  end

  def down
    remove_column :payments, :freelancer_avj_fees_rate, :decimal, precision: 10, scale: 2
    remove_column :payments, :company_avj_fees_rate, :decimal, precision: 10, scale: 2
  end
end
