class RemoveFieldsFromProjects < ActiveRecord::Migration[5.1]
  def change
    remove_column :projects, :budget, :string
    remove_column :projects, :address, :string
    remove_column :projects, :area, :string
    remove_column :projects, :duration, :integer
    remove_column :projects, :starts_on, :date
    remove_column :projects, :closed, :boolean
    remove_column :projects, :currency, :string
  end
end
