# frozen_string_literal: true

class AddQuoteAuthorType < ActiveRecord::Migration[5.1]
  def change
    add_column :quotes, :author_type, :string, default: "freelancer"
  end
end
