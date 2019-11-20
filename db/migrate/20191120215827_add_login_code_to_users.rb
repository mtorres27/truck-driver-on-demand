class AddLoginCodeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :login_code, :string
  end
end
