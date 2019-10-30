# frozen_string_literal: true

class AddScopeFileToJob < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, "scope_file_data", :text
  end
end
