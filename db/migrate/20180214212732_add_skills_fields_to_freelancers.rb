class AddSkillsFieldsToFreelancers < ActiveRecord::Migration[5.1]
  def change
    add_column :freelancers, :job_type, :string
    add_column :freelancers, :job_functions, :citext, index: true
    rename_column :freelancers, :keywords, :job_markets
    rename_column :freelancers, :skills, :technical_skills
    add_column :freelancers, :manufacturer_tags, :citext, index: true
  end
end
