# frozen_string_literal: true

class AddCompanyProfileViews < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, "profile_views", :integer, null: false, default: 0
  end
end
