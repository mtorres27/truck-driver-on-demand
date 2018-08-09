class AddAvjFeesRateToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :freelancer_avj_fees_rate, :decimal, precision: 10, scale: 2
    add_column :payments, :company_avj_fees_rate, :decimal, precision: 10, scale: 2

    Payment.find_each do |payment|
      if payment.company.plan&.fee_schema.present?
        company_avj_fees_rate = payment.company.plan&.fee_schema['company_fees']
        freelancer_avj_fees_rate = payment.company.plan&.fee_schema['freelancer_fees']
        payment.update_attributes(company_avj_fees_rate: company_avj_fees_rate, freelancer_avj_fees_rate: freelancer_avj_fees_rate)
      end
    end
  end

  def down
    remove_column :payments, :freelancer_avj_fees_rate, :decimal, precision: 10, scale: 2
    remove_column :payments, :company_avj_fees_rate, :decimal, precision: 10, scale: 2
  end
end
