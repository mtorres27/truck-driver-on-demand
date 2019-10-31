# frozen_string_literal: true

class AddFieldsToProfile < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, "website", :string
  end
end
