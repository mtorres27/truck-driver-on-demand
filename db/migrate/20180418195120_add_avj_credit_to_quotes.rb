# frozen_string_literal: true

class AddAvjCreditToQuotes < ActiveRecord::Migration[5.1]
  def change
    add_column :quotes, :avj_credit, :decimal, precision: 10, scale: 2, default: nil
  end
end
