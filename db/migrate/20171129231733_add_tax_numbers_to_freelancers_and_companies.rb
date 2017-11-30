class AddTaxNumbersToFreelancersAndCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :sales_tax_number, :string
    add_column :freelancers, :sales_tax_number, :string
  end
end
