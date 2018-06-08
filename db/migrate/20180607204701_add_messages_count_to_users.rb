class AddMessagesCountToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :messages_count, :integer, null: false, default: 0
  end
end
