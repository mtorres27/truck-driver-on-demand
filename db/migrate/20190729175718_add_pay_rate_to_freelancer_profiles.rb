class AddPayRateToFreelancerProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :freelancer_profiles, :pay_rate, :float
  end
end
