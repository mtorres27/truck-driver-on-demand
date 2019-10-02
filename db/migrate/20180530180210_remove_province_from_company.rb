class RemoveProvinceFromCompany < ActiveRecord::Migration[5.1]
  def self.up
    remove_column :companies, :province, :string
  end

  def self.down
    add_column :companies, :province, :string
  end
end
