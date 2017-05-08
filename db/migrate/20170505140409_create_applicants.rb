class CreateApplicants < ActiveRecord::Migration[5.1]
  def change
    create_table :applicants do |t|
      t.references :job, foreign_key: true, index: true
      t.references :freelancer, foreign_key: true, index: true
      t.decimal :quote, precision: 10, scale: 2, null: false
      t.boolean :accepted, null: false, default: false

      t.timestamps
    end
  end
end
