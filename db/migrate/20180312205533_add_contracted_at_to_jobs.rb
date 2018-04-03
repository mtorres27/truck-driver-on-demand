class AddContractedAtToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :contracted_at, :datetime
  end
end
