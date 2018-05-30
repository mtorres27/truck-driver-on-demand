class RemoveProvinceFromCompany < ActiveRecord::Migration[5.1]
  def change
    Company.where.not(province: nil).each do |company|
      company.update_attribute(:state, company.province.downcase)
    end

    remove_column :companies, :province, :string
  end
end
