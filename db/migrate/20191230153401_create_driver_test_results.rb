class CreateDriverTestResults < ActiveRecord::Migration[5.1]
  def change
    create_table :driver_test_results do |t|
      t.references :driver_test, foreign_key: true, null: false, index: true
      t.references :driver, foreign_key: { to_table: :users }, null: false, index: true
      t.jsonb :answers
      t.float :score

      t.timestamps
    end
  end
end
