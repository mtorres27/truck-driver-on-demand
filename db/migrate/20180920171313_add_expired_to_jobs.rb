class AddExpiredToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :expired, :boolean, default: false
  end
end
