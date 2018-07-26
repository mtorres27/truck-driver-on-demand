class AddPaidByCompanyToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :paid_by_company, :boolean, default: false
  end
end
