# frozen_string_literal: true

class AddFieldsToMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, "checkin", :boolean, default: false
    add_column :messages, "counter_offer", :string
  end
end
