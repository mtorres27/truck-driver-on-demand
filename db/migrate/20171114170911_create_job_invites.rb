# frozen_string_literal: true

class CreateJobInvites < ActiveRecord::Migration[5.1]
  def change
    create_table :job_invites do |t|
      t.integer :job_id
      t.integer :freelancer_id
      t.timestamps
    end
  end
end
