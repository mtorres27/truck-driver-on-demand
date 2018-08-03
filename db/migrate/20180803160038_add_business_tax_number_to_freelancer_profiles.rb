class AddBusinessTaxNumberToFreelancerProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :freelancer_profiles, :business_tax_number, :string
  end
end
