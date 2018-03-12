class AddImageDataToFreelancerAffiliation < ActiveRecord::Migration[5.1]
  def change
    add_column :freelancer_affiliations, :image_data, :text
  end
end
