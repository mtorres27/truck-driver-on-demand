# frozen_string_literal: true

class ChangeStateDefault < ActiveRecord::Migration[5.1]
  def change
    change_column :applicants, :state, :string, default: "quoting"
  end
end
