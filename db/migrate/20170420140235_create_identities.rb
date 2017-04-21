class CreateIdentities < ActiveRecord::Migration[5.1]
  def change
    create_table :identities do |t|
      t.references :loginable, polymorphic: true, index: true
      t.string :provider, null: false
      t.string :uid, null: false

      t.timestamps
    end

    add_index :identities, [:loginable_type, :provider, :uid]
  end
end
