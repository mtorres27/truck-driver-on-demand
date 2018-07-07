class RemoveNullConstraintsFromJobs < ActiveRecord::Migration[5.1]
  def change
    change_column_null :jobs, :job_function, true
    change_column_null :jobs, :freelancer_type, true
  end
end
