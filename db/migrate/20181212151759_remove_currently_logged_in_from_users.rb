class RemoveCurrentlyLoggedInFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :currently_logged_in, :boolean
  end
end
