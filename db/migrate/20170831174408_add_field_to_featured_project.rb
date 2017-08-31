class AddFieldToFeaturedProject < ActiveRecord::Migration[5.1]
  def change
    add_column :featured_projects, 'file_data', :string
  end
end
