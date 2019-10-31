# frozen_string_literal: true

class CreateCompanyReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :company_reviews do |t|
      t.references :company, foreign_key: true
      t.references :freelancer, foreign_key: true
      t.references :job, foreign_key: true
      t.integer :quality_of_information_provided, null: false
      t.integer :communication, null: false
      t.integer :materials_available_onsite, null: false
      t.integer :promptness_of_payment, null: false
      t.integer :overall_experience, null: false
      t.text :comments

      t.timestamps
    end
  end
end
