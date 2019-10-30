# frozen_string_literal: true

class AddStripeInvoiceNumberToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :stripe_invoice_number, :string
  end
end
