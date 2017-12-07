class AddChargeIdToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :stripe_charge_id, :string
  end
end
