# frozen_string_literal: true

class AddFieldsToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :saved_freelancers_ids, :citext
  end
end
