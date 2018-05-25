class AddLocationToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :state_province, :string
  end
end
