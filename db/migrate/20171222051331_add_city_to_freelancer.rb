# frozen_string_literal: true

class AddCityToFreelancer < ActiveRecord::Migration[5.1]
  def change
    add_column :freelancers, :city, :string
  end
end
