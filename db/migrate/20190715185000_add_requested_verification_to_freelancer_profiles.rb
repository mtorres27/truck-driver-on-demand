# frozen_string_literal: true

class AddRequestedVerificationToFreelancerProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :freelancer_profiles, :requested_verification, :boolean, default: false
  end
end
