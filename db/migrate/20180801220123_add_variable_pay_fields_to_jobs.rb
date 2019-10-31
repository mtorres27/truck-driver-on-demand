# frozen_string_literal: true

class AddVariablePayFieldsToJobs < ActiveRecord::Migration[5.1]
  def up
    add_column :jobs, :variable_pay_type, :string
    add_column :jobs, :overtime_rate, :decimal, precision: 10, scale: 2

    Job.find_each do |job|
      if job.pay_type == "hourly"
        job.update_attributes(pay_type: "variable", variable_pay_type: "hourly")
      elsif job.pay_type == "daily"
        job.update_attributes(pay_type: "variable", variable_pay_type: "daily")
      end
    end
  end

  def down
    Job.find_each do |job|
      if job.variable_pay_type == "hourly"
        job.update_attributes(pay_type: "hourly")
      elsif job.variable_pay_type == "daily"
        job.update_attributes(pay_type: "daily")
      end
    end

    remove_column :jobs, :variable_pay_type, :string
    remove_column :jobs, :overtime_rate, :decimal, precision: 10, scale: 2
  end
end
