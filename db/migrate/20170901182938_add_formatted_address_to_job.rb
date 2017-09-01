class AddFormattedAddressToJob < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :formatted_address, :string
  end
end
