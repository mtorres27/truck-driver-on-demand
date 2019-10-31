# frozen_string_literal: true

class DropProjects < ActiveRecord::Migration[5.1]
  def change
    remove_column :jobs, :project_id
    drop_table :projects
  end
end
