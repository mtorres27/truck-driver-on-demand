class CreateApplicants < ActiveRecord::Migration[5.1]
  def change
    create_table :applicants do |t|
      t.references :job, foreign_key: true, null: false, index: true
      t.references :freelancer, foreign_key: true, null: false, index: true
      t.string :state, null: false, default: "interested"

      t.integer :quotes_count, null: false, default: 0

      t.timestamps
    end
  end
end
