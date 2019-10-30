# frozen_string_literal: true

class CreateFriendInvites < ActiveRecord::Migration[5.1]
  def change
    create_table :friend_invites do |t|
      t.citext :email, null: false
      t.string :name, null: false
      t.references :freelancer, index: true, null: false
      t.boolean :accepted, default: false
    end
  end
end
