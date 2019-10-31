# frozen_string_literal: true

class RemoveFieldsFromJobs < ActiveRecord::Migration[5.1]
  def change
    remove_column :jobs, :scope_of_work, :text
    remove_column :jobs, :budget, :float
    remove_column :jobs, :job_function, :string
    remove_column :jobs, :starts_on, :date
    remove_column :jobs, :ends_on, :date
    remove_column :jobs, :duration, :integer
    remove_column :jobs, :pay_type, :string
    remove_column :jobs, :freelancer_type, :string
    remove_column :jobs, :invite_only, :boolean
    remove_column :jobs, :scope_is_public, :boolean
    remove_column :jobs, :budget_is_public, :boolean
    remove_column :jobs, :working_days, :text
    remove_column :jobs, :working_time, :string
    remove_column :jobs, :contract_price, :float
    remove_column :jobs, :payment_schedule, :jsonb
    remove_column :jobs, :reporting_frequency, :string
    remove_column :jobs, :require_photos_on_updates, :boolean
    remove_column :jobs, :require_checkin, :boolean
    remove_column :jobs, :require_uniform, :boolean
    remove_column :jobs, :addendums, :text
    remove_column :jobs, :applicants_count, :integer
    remove_column :jobs, :messages_count, :integer
    remove_column :jobs, :currency, :string
    remove_column :jobs, :contract_sent, :boolean
    remove_column :jobs, :opt_out_of_freelance_service_agreement, :boolean
    remove_column :jobs, :scope_file_data, :text
    remove_column :jobs, :applicable_sales_tax, :float
    remove_column :jobs, :stripe_charge_id, :string
    remove_column :jobs, :stripe_balance_transaction_id, :string
    remove_column :jobs, :funds_available_on, :integer
    remove_column :jobs, :funds_available, :boolean
    remove_column :jobs, :job_type, :citext
    remove_column :jobs, :company_plan_fees, :float
    remove_column :jobs, :contracted_at, :datetime
    remove_column :jobs, :creation_step, :string
    remove_column :jobs, :plan_fee, :float
    remove_column :jobs, :paid_by_company, :boolean
    remove_column :jobs, :total_amount, :float
    remove_column :jobs, :tax_amount, :float
    remove_column :jobs, :stripe_fees, :float
    remove_column :jobs, :amount_subtotal, :float
    remove_column :jobs, :overtime_rate, :float
    remove_column :jobs, :variable_pay_type, :string
    remove_column :jobs, :payment_terms, :integer
    remove_column :jobs, :expired, :boolean
    remove_column :jobs, :fee_schema, :json
    remove_column :jobs, :creator_id, :integer

    rename_column :jobs, :job_market, :job_markets
  end
end
