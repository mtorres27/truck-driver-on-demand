class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.references :job, foreign_key: true, index: true
      t.references :authorable, polymorphic: true, index: true
      t.text :body
      t.text :attachment_data

      t.timestamps
    end
  end
end
