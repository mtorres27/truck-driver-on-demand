class AddHeaderSourceToProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :freelancers, :header_source, :string, default: "color"
    add_column :companies, :header_source, :string, default: "color"

  end
end
