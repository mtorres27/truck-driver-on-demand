# frozen_string_literal: true

class CreateCompanyInstalls < ActiveRecord::Migration[5.1]
  def change
    create_table :company_installs do |t|
      t.integer "company_id"
      t.integer "year"
      t.integer "installs"
      t.timestamps
    end
  end
end
