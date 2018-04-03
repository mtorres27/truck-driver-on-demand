class AddSkillsFieldsToCompany < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :job_types, :citext
    rename_column :companies, :keywords, :job_markets
    rename_column :companies, :skills, :technical_skill_tags
    add_column :companies, :manufacturer_tags, :citext, index: true
  end
end
