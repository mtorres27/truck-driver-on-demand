# frozen_string_literal: true

class CreateCurrencyRates < ActiveRecord::Migration[5.1]
  def change
    create_table :currency_rates do |t|
      t.string :currency
      t.string :country
      t.decimal :rate, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
