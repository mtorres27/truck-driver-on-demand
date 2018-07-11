class RemoveNullConstraintsFromJobs < ActiveRecord::Migration[5.1]
  def change
    change_column_null :jobs, :job_function, true
    change_column_null :jobs, :freelancer_type, true
    change_column_null :jobs, :title, true
    change_column_null :jobs, :summary, true
    change_column_null :jobs, :budget, true
    change_column_null :jobs, :starts_on, true
    change_column_null :jobs, :duration, true
    change_column_null :jobs, :project_id, true
  end
end
