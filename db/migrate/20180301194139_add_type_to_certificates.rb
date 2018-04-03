class AddTypeToCertificates < ActiveRecord::Migration[5.1]
  def change
    add_column :certifications, :cert_type, :string
  end
end
