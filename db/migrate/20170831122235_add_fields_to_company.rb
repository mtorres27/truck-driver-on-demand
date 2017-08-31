class AddFieldsToCompany < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, 'keywords', :citext, index: true
    add_column :companies, 'skills', :citext, index: true
  end
end
