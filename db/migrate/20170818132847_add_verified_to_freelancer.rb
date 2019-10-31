# frozen_string_literal: true

class AddVerifiedToFreelancer < ActiveRecord::Migration[5.1]
  def change
    add_column :freelancers, :verified, :boolean, default: true
  end
end
