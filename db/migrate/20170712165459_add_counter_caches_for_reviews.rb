# frozen_string_literal: true

class AddCounterCachesForReviews < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :company_reviews_count, :integer, null: false, default: 0
    add_column :freelancers, :freelancer_reviews_count, :integer, null: false, default: 0
  end
end
