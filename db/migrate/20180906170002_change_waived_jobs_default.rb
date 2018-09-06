class ChangeWaivedJobsDefault < ActiveRecord::Migration[5.1]
  def up
    change_column_default :companies, :waived_jobs, 0
  end

  def down
    change_column_default :companies, :waived_jobs, 1
  end
end
