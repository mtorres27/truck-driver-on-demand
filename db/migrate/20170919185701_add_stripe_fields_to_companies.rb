class AddStripeFieldsToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :stripe_customer_id, :string, limit: 40
    add_column :companies, :is_active, :boolean, default: false
    add_column :companies, :expires_at, :datetime
    add_column :companies, :last_4_digits, :string, limit: 4
    add_column :companies, :card_brand, :string, limit: 20
    add_column :companies, :exp_month, :string, limit: 2
    add_column :companies, :exp_year, :string, limit: 4
  end
end
