# frozen_string_literal: true

class AddAttributesToFreelancers < ActiveRecord::Migration[5.1]
  def change
    add_column :freelancers, :profile_score, :integer, limit: 1
    add_column :freelancers, :valid_freelancer, :boolean
    add_column :freelancers, :own_tools, :boolean
    add_column :freelancers, :company_name, :string
  end
end
