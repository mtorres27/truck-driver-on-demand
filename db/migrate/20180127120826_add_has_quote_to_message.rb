# frozen_string_literal: true

class AddHasQuoteToMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :has_quote, :boolean, default: false
  end
end
