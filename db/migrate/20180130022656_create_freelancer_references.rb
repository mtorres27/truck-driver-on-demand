class CreateFreelancerReferences < ActiveRecord::Migration[5.1]
  def change
    create_table :freelancer_references do |t|
      t.string :name
      t.string :title
      t.text :description
      t.string :phone, limit: 12
      t.integer :freelancer_id
      t.timestamps
    end
  end
end
