# frozen_string_literal: true

class CreatePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :plans do |t|
      t.string :name
      t.string :code
      t.integer :trial_period
      t.decimal :subscription_fee
      t.json :fee_schema

      t.timestamps
    end
  end
end
