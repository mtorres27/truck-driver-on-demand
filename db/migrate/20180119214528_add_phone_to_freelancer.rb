# frozen_string_literal: true

class AddPhoneToFreelancer < ActiveRecord::Migration[5.1]
  def change
    add_column :freelancers, :phone_number, :string unless column_exists?("freelancers", "phone_number")
  end
end
