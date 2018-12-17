class AddCurrentlyLoggedInToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :currently_logged_in, :boolean
  end
end
