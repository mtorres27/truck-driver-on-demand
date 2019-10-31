# frozen_string_literal: true

class AddCreatorIdToJobs < ActiveRecord::Migration[5.1]
  def change
    add_reference :jobs, :creator, references: :users
    add_foreign_key :jobs, :users, column: :creator_id
  end
end
