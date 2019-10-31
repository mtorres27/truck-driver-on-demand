# frozen_string_literal: true

class AddJobPostingLimitToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :job_posting_limit, :integer
  end
end
