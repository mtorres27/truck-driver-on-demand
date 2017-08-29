class ModifyJobAttachments < ActiveRecord::Migration[5.1]
  def change
    rename_column :attachments, :filename, :file_data
    
  end
end
