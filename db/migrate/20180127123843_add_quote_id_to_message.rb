# frozen_string_literal: true

class AddQuoteIdToMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :quote_id, :integer, length: 11
  end
end
