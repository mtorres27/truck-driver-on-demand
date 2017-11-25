class AddFeesBreakdownToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :avj_fees, :decimal, precision: 10, scale: 2, null: true

    add_column :quotes, :avj_fees, :decimal, precision: 10, scale: 2, null: true
    add_column :quotes, :stripe_fees, :decimal, precision: 10, scale: 2, null: true
    add_column :quotes, :net_avj_fees, :decimal, precision: 10, scale: 2, null: true

    add_column :quotes, :total_amount, :decimal, precision: 10, scale: 2, null: true
  end
end
