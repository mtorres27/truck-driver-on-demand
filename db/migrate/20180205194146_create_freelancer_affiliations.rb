class CreateFreelancerAffiliations < ActiveRecord::Migration[5.1]
  def change
    create_table :freelancer_affiliations do |t|
      t.string :name
      t.string :image
      t.integer :freelancer_id

      t.timestamps
    end
  end
end
