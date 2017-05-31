class CreateIdentities < ActiveRecord::Migration[5.1]
  def change
    create_table :identities do |t|
      t.references :loginable, polymorphic: true, index: true, null: false
      t.string :provider, null: false
      t.string :uid, null: false
      t.datetime :last_sign_in_at

      t.timestamps
    end

    add_index :identities, [:loginable_type, :provider, :uid]
  end
end
