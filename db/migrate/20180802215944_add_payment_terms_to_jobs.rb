class AddPaymentTermsToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :payment_terms, :integer
  end
end
