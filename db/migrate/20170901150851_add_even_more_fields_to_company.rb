# frozen_string_literal: true

class AddEvenMoreFieldsToCompany < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, "number_of_offices", :integer, default: 0
    add_column :companies, "number_of_employees", :string
    add_column :companies, "established_in", :integer
  end
end
