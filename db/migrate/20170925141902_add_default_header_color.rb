# frozen_string_literal: true

class AddDefaultHeaderColor < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, "header_color", :string, default: "FF6C38"
    add_column :freelancers, "header_color", :string, default: "FF6C38"
  end
end
