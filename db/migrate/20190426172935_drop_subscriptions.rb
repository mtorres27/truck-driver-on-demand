# frozen_string_literal: true

class DropSubscriptions < ActiveRecord::Migration[5.1]
  def change
    remove_column :companies, :plan_id, :integer
    remove_column :companies, :stripe_customer_id, :string
    remove_column :companies, :stripe_subscription_id, :string
    remove_column :companies, :stripe_plan_id, :string
    remove_column :companies, :subscription_cycle, :string
    remove_column :companies, :is_subscription_cancelled, :boolean
    remove_column :companies, :subscription_status, :string
    remove_column :companies, :billing_period_ends_at, :datetime
    remove_column :companies, :last_4_digits, :string
    remove_column :companies, :card_brand, :string
    remove_column :companies, :exp_month, :string
    remove_column :companies, :exp_year, :string
    remove_column :companies, :is_trial_applicable, :boolean
    remove_column :companies, :waived_jobs, :integer

    drop_table :plans
    drop_table :subscriptions
  end
end
