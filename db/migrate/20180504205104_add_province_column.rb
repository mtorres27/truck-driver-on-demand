class AddProvinceColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :freelancers, :province, :string
  end
end
