# frozen_string_literal: true

class RemovePhoneNumberFromFreelancerProfiles < ActiveRecord::Migration[5.1]
  def change
    remove_column :freelancer_profiles, :phone_number, :string
  end
end
