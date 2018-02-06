class CreateFreelancerInsurances < ActiveRecord::Migration[5.1]
  def change
    create_table :freelancer_insurances do |t|
      t.string :name
      t.text :description
      t.integer :freelancer_id

      t.timestamps
    end
  end
end
