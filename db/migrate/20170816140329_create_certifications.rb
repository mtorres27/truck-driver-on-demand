# frozen_string_literal: true

class CreateCertifications < ActiveRecord::Migration[5.1]
  def change
    create_table :certifications do |t|
      t.integer :freelancer_id
      t.text :image
      t.text :name
      t.timestamps
    end
  end
end
