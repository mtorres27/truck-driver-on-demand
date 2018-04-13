class CreateFriendInvites < ActiveRecord::Migration[5.1]
  def change
    create_table :friend_invites do |t|
      t.citext :email
      t.string :name
      t.references :freelancer, index: true
      t.boolean :accepted, default: false
    end
  end
end
