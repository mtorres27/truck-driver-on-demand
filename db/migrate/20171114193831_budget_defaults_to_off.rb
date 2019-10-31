# frozen_string_literal: true

class BudgetDefaultsToOff < ActiveRecord::Migration[5.1]
  def change
    change_column :jobs, :budget_is_public, :boolean, default: false
  end
end
