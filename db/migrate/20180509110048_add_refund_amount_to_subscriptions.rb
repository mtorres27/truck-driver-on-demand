# frozen_string_literal: true

class AddRefundAmountToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :refund, :decimal, precision: 10, scale: 2, default: 0
    add_column :subscriptions, :tax, :decimal, precision: 10, scale: 2, default: 0
    add_column :subscriptions, :description, :string
  end
end
