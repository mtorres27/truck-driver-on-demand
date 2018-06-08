class RemoveProvinceFromCompany < ActiveRecord::Migration[5.1]
  def self.up
    Company.where.not(province: nil).each do |company|
      company.update_attribute(:state, company.province.downcase)
    end

    remove_column :companies, :province, :string
  end

  def self.down
    add_column :companies, :province, :string
  end
end
