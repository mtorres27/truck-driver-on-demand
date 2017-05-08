class CreateJobMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :job_messages do |t|
      t.references :job, foreign_key: true, index: true
      t.references :authorable, polymorphic: true, index: true
      t.text :message
      t.text :attachment_data

      t.timestamps
    end
  end
end
