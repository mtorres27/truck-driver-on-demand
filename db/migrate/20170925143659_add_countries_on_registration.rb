# frozen_string_literal: true

class AddCountriesOnRegistration < ActiveRecord::Migration[5.1]
  def change
    add_column :freelancers, :country, :string
    add_column :companies, :country, :string
  end
end
