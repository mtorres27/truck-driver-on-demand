class AddAddressDetailsToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :line2, :string
    add_column :companies, :city, :string
    add_column :companies, :state, :string
    add_column :companies, :postal_code, :string
  end
end
