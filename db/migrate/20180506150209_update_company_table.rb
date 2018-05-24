class UpdateCompanyTable < ActiveRecord::Migration[5.1]
  def change
    change_column :companies, :name, :string, null: true
    change_column :companies, :contact_name, :string, null: true
    add_column :companies, :registration_step, :string
  end
end
