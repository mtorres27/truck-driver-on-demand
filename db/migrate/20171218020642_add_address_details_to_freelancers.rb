class AddAddressDetailsToFreelancers < ActiveRecord::Migration[5.1]
  def change
    add_column :freelancers, :line2, :string
    add_column :freelancers, :state, :string
    add_column :freelancers, :postal_code, :string
    add_column :freelancers, :service_areas, :string
  end
end
