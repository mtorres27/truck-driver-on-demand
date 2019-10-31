# frozen_string_literal: true

class AddWaivedsJobToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :waived_jobs, :integer, default: 1
  end
end
