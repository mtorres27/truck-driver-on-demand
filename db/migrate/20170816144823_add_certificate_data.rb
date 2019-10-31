# frozen_string_literal: true

class AddCertificateData < ActiveRecord::Migration[5.1]
  def change
    add_column :certifications, "certificate_data", :text
  end
end
