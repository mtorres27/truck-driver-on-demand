class CreateTestQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :test_questions do |t|
      t.references :driver_test, foreign_key: true, null: false, index: true
      t.string :question, null: false
      t.jsonb :options, null: false
      t.integer :answer, null: false

      t.timestamps
    end
  end
end
