# frozen_string_literal: true

class AddUnreadToMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, "unread", :boolean, default: true
  end
end
