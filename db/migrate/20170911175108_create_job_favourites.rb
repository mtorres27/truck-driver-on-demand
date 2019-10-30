# frozen_string_literal: true

class CreateJobFavourites < ActiveRecord::Migration[5.1]
  def change
    create_table :job_favourites do |t|
      t.integer :freelancer_id
      t.integer :job_id
      t.timestamps
    end
  end
end
