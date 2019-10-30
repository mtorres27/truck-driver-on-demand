# frozen_string_literal: true

class MakeStripeAttrNullable < ActiveRecord::Migration[5.1]
  def change
    change_column :companies, :stripe_customer_id, :string, null: true
    change_column :companies, :stripe_subscription_id, :string, null: true
    change_column :companies, :stripe_plan_id, :string, null: true
    change_column :companies, :subscription_cycle, :string, null: true
    change_column :companies, :subscription_status, :string, null: true
    change_column :companies, :billing_period_ends_at, :datetime, null: true
    change_column :companies, :last_4_digits, :string, null: true
    change_column :companies, :card_brand, :string, null: true
    change_column :companies, :exp_month, :string, null: true
    change_column :companies, :exp_year, :string, null: true
  end
end
