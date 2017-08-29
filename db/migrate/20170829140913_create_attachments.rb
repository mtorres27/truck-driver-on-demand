class CreateAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.string "filename"
      t.integer "job_id"
      t.timestamps
    end
  end
end
