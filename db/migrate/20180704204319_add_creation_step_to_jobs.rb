# frozen_string_literal: true

class AddCreationStepToJobs < ActiveRecord::Migration[5.1]
  def up
    add_column :jobs, :creation_step, :string

    Job.find_each do |job|
      job.update_attribute(:creation_step, "wicked_finish")
    end
  end

  def down
    remove_column :jobs, :creation_step, :string
  end
end
