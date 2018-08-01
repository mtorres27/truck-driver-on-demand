class RemoveQuoteIdFromMessages < ActiveRecord::Migration[5.1]
  def change
    remove_column :messages, :quote_id, :integer
  end
end
