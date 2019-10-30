# frozen_string_literal: true

class AddDailyRateToQuote < ActiveRecord::Migration[5.1]
  def change
    add_column :quotes, :number_of_days, :integer
    add_column :quotes, :daily_rate, :integer
  end
end
