# frozen_string_literal: true

class DropPaymentsTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :payments
  end
end
