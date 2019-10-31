# frozen_string_literal: true

class AddLocationToJob < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, "location", :string
    add_column :jobs, "lat", :decimal, precision: 9, scale: 6
    add_column :jobs, "lng", :decimal, precision: 9, scale: 6
  end
end
