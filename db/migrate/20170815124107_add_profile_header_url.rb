# frozen_string_literal: true

class AddProfileHeaderUrl < ActiveRecord::Migration[5.1]
  def change
    add_column :freelancers, "profile_header_data", :text
    add_column :companies, "profile_header_data", :text
  end
end
