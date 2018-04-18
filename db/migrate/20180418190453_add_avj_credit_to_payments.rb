class AddAvjCreditToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :avj_credit, :decimal, precision: 10, scale: 2, default: nil
  end
end
