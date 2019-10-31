# frozen_string_literal: true

class AddIsCanadianToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :is_canadian, :boolean, default: false
  end
end
