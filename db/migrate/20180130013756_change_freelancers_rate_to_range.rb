class ChangeFreelancersRateToRange < ActiveRecord::Migration[5.1]
  def self.up
    change_column :freelancers, :pay_per_unit_time, :string
  end

  def self.down
    change_column :freelancers, :pay_per_unit_time, :integer
  end
end
