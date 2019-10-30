# frozen_string_literal: true

class ChangeHeaderDefaults < ActiveRecord::Migration[5.1]
  def change
    change_column_default :freelancer_profiles, :header_source, from: "color", to: "default"
    change_column_default :companies, :header_source, from: "color", to: "default"
  end
end
