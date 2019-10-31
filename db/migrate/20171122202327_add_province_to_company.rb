# frozen_string_literal: true

class AddProvinceToCompany < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :province, :string
  end
end
