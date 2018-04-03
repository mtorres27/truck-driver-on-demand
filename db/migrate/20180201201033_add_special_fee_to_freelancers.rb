class AddSpecialFeeToFreelancers < ActiveRecord::Migration[5.1]
  def change
    add_column :freelancers, :special_avj_fees, :decimal, precision: 10, scale: 2, null: true
  end
end
