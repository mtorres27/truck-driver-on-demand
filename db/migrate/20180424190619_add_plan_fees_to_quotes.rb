# frozen_string_literal: true

class AddPlanFeesToQuotes < ActiveRecord::Migration[5.1]
  def change
    add_column :quotes, :plan_fee, :decimal, precision: 10, scale: 2, default: 0
  end
end
