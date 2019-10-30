# frozen_string_literal: true

class DropFreelancerReferences < ActiveRecord::Migration[5.1]
  def up
    drop_table :freelancer_references
  end

  def down
    create_table :freelancer_references do |t|
      t.string :name
      t.string :title
      t.text :description
      t.string :phone, limit: 12
      t.integer :freelancer_id
      t.timestamps
    end
  end
end
