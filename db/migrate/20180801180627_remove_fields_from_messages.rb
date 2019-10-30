# frozen_string_literal: true

class RemoveFieldsFromMessages < ActiveRecord::Migration[5.1]
  def change
    remove_column :messages, :quote_id, :integer
    remove_column :messages, :has_quote, :boolean
  end
end
