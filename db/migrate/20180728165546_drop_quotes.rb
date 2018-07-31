class DropQuotes < ActiveRecord::Migration[5.1]
  def change
    Job.find_each do |job|
      if job.applicants.with_state(:accepted).count > 0
        accepted_applicant = job.applicants.with_state(:accepted).first
        accepted_quote = execute("select * from quotes where state = 'accepted' and applicant_id = #{accepted_applicant.id}").first
        job.update_attributes(total_amount: accepted_quote['total_amount'],
                              tax_amount: accepted_quote['tax_amount'],
                              stripe_fees: accepted_quote['stripe_fees'],
                              plan_fee: accepted_quote['plan_fee'],
                              amount_subtotal: accepted_quote['amount']
        )
      end
    end

    drop_table :quotes
  end
end
