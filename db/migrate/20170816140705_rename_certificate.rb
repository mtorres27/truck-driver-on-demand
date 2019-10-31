# frozen_string_literal: true

class RenameCertificate < ActiveRecord::Migration[5.1]
  def change
    rename_column :certifications, :image, :certificate
  end
end
