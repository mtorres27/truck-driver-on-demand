class CreateJobCollaborator < ActiveRecord::Migration[5.1]
  def change
    create_table :job_collaborators do |t|
      t.references :job, foreign_key: true, null: false, index: true
      t.references :user, foreign_key: true, null: false, index: true
      t.boolean :receive_notifications, default: true
    end
  end
end
