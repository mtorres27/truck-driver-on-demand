# frozen_string_literal: true

class ChangeVerifiedToFreelancer < ActiveRecord::Migration[5.1]
  def change
    change_column :freelancers, :verified, :boolean, default: false
  end
end
