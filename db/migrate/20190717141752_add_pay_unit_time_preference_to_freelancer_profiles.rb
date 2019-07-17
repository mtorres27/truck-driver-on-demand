class AddPayUnitTimePreferenceToFreelancerProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :freelancer_profiles, :pay_unit_time_preference, :string
  end
end
