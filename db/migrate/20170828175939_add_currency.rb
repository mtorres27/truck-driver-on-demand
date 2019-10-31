# frozen_string_literal: true

class AddCurrency < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :currency, :string
  end
end
