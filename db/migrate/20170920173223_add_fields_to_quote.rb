# frozen_string_literal: true

class AddFieldsToQuote < ActiveRecord::Migration[5.1]
  def change
    add_column :quotes, :number_of_hours, :integer
    add_column :quotes, :hourly_rate, :integer
  end
end
