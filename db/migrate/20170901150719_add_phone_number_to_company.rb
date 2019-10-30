# frozen_string_literal: true

class AddPhoneNumberToCompany < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, "phone_number", :string
  end
end
