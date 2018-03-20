class AddAcceptedAtToQuotes < ActiveRecord::Migration[5.1]
  def change
    add_column :quotes, :accepted_at, :datetime
  end
end
