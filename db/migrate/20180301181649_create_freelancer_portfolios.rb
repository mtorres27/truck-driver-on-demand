# frozen_string_literal: true

class CreateFreelancerPortfolios < ActiveRecord::Migration[5.1]
  def change
    create_table :freelancer_portfolios do |t|
      t.text :name
      t.string :image
      t.text :image_data
      t.integer :freelancer_id

      t.timestamps
    end
  end
end
