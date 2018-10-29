class AddStripeInvoiceDateToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :stripe_invoice_date, :datetime
  end
end
