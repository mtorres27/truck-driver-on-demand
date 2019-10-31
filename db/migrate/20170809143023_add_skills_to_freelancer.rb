# frozen_string_literal: true

class AddSkillsToFreelancer < ActiveRecord::Migration[5.1]
  def change
    add_column :freelancers, "skills", :citext, index: true
  end
end
