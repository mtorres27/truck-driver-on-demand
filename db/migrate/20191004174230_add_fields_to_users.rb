class AddFieldsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :role, :string
    add_column :users, :enabled, :boolean, default: true
  end
end
