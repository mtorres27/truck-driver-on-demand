class AddFeeSchemaToJobs < ActiveRecord::Migration[5.1]
  def up
    add_column :jobs, :fee_schema, :json

    Job.find_each do |job|
      job.update_columns(fee_schema: job.company&.plan&.fee_schema)
    end
  end

  def down
    remove_column :jobs, :fee_schema, :json
  end
end
