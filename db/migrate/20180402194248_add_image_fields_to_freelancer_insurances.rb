class AddImageFieldsToFreelancerInsurances < ActiveRecord::Migration[5.1]
  def change
    add_column :freelancer_insurances, :image, :string
    add_column :freelancer_insurances, :image_data, :text
  end
end
