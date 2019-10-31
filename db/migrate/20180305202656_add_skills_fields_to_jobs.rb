# frozen_string_literal: true

class AddSkillsFieldsToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :job_type, :citext
    add_column :jobs, :job_market, :citext
    rename_column :jobs, :keywords, :technical_skill_tags
    add_column :jobs, :manufacturer_tags, :citext, index: true
  end
end
