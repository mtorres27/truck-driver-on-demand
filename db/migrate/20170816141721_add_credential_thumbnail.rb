class AddCredentialThumbnail < ActiveRecord::Migration[5.1]
  def change
    add_column :certifications, :thumbnail, :text
  end
end
