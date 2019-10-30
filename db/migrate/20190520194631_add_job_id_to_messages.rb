# frozen_string_literal: true

class AddJobIdToMessages < ActiveRecord::Migration[5.1]
  def change
    add_reference :messages, :job, foreign_key: { to_table: :jobs }, index: true
  end
end
