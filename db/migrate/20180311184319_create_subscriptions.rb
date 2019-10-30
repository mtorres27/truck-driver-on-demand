# frozen_string_literal: true

class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.integer :company_id
      t.integer :plan_id
      t.string :stripe_subscription_id
      t.boolean :is_active
      t.date :ends_at
      t.date :billing_perios_ends_at
      t.decimal :amount

      t.timestamps
    end
  end
end
