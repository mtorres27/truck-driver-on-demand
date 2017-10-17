class AddStripeToFreelancers < ActiveRecord::Migration[5.1]
  def change
    add_column :freelancers, :stripe_account_id, :string
    add_column :freelancers, :stripe_account_status, :text
    add_column :freelancers, :currency, :string
  end
end
