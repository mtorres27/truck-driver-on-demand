# frozen_string_literal: true

class AddMessageCountersToRelevantTables < ActiveRecord::Migration[5.1]
  def change
    add_column :freelancers, :messages_count, :integer, null: false, default: 0
    add_column :companies, :messages_count, :integer, null: false, default: 0
    add_column :applicants, :messages_count, :integer, null: false, default: 0
  end
end
