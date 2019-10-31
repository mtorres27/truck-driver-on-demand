# frozen_string_literal: true

class CreateFreelancerReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :freelancer_reviews do |t|
      t.references :freelancer, foreign_key: true
      t.references :company, foreign_key: true
      t.references :job, foreign_key: true
      t.integer :availability, null: false
      t.integer :communication, null: false
      t.integer :adherence_to_schedule, null: false
      t.integer :skill_and_quality_of_work, null: false
      t.integer :overall_experience, null: false
      t.text :comments

      t.timestamps
    end
  end
end
