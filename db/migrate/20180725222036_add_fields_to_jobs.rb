# frozen_string_literal: true

class AddFieldsToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :plan_fee, :decimal, precision: 10, scale: 2, default: 0
    add_column :jobs, :paid_by_company, :boolean, default: false
    add_column :jobs, :total_amount, :decimal, precision: 10, scale: 2
    add_column :jobs, :tax_amount, :decimal, precision: 10, scale: 2
    add_column :jobs, :stripe_fees, :decimal, precision: 10, scale: 2
    add_column :jobs, :amount_subtotal, :decimal, precision: 10, scale: 2
  end
end
