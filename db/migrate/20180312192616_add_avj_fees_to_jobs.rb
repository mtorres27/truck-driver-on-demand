class AddAvjFeesToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :avj_fees, :integer, default: 0
  end
end
