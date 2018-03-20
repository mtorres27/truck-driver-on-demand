class CreateFreelancerClearances < ActiveRecord::Migration[5.1]
  def change
    create_table :freelancer_clearances do |t|
      t.text :description
      t.string :image
      t.text :image_data
      t.integer :freelancer_id

      t.timestamps
    end
  end
end
