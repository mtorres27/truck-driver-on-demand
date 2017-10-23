class AddServiceAgreementOptOut < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, 'opt_out_of_freelance_service_agreement', :boolean, default: false
  end
end
