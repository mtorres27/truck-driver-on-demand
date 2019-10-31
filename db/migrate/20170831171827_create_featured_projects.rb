# frozen_string_literal: true

class CreateFeaturedProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :featured_projects do |t|
      t.integer :company_id
      t.string :name
      t.string :file
      t.timestamps
    end
  end
end
