# frozen_string_literal: true

class AddTitleToAttachment < ActiveRecord::Migration[5.1]
  def change
    add_column :attachments, :title, :string
  end
end
