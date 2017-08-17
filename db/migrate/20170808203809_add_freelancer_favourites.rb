class AddFreelancerFavourites < ActiveRecord::Migration[5.1]
  def change
    create_table :favourites do |t|
      t.integer :freelancer_id
      t.integer :company_id
      t.timestamps
    end
  end
end
