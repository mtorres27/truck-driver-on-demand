class CreateDriverTests < ActiveRecord::Migration[5.1]
  def change
    create_table :driver_tests do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
