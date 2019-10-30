# frozen_string_literal: true

class AddVariablePayFieldsToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :time_unit_amount, :integer
    add_column :payments, :overtime_hours_amount, :integer
  end
end
