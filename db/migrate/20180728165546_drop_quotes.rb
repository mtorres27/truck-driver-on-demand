class DropQuotes < ActiveRecord::Migration[5.1]
  def up
    add_column :jobs, :total_amount, :decimal, precision: 10, scale: 2
    add_column :jobs, :tax_amount, :decimal, precision: 10, scale: 2
    add_column :jobs, :stripe_fees, :decimal, precision: 10, scale: 2
    add_column :jobs, :plan_fees, :decimal, precision: 10, scale: 2
    add_column :jobs, :amount_subtotal, :decimal, precision: 10, scale: 2

    Job.find_each do |job|
      if job.applicants.with_state(:accepted).count > 0
        accepted_applicant = job.applicants.with_state(:accepted).first
        accepted_quote = execute("select * from quotes where state = 'accepted' and applicant_id = #{accepted_applicant.id}").first
        job.update_attributes(total_amount: accepted_quote['total_amount'],
                              tax_amount: accepted_quote['tax_amount'],
                              stripe_fees: accepted_quote['stripe_fees'],
                              plan_fees: accepted_quote['plan_fee'],
                              amount_subtotal: accepted_quote['amount']
        )
      end
    end

    drop_table :quotes
  end

  def down

  end
end
