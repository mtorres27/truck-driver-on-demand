class RemoveFieldsFromFreelancerProfiles < ActiveRecord::Migration[5.1]
  def change
    remove_column :freelancer_profiles, :pay_unit_time_preference, :string
    remove_column :freelancer_profiles, :pay_per_unit_time, :string
    remove_column :freelancer_profiles, :projects_completed, :integer
    remove_column :freelancer_profiles, :profile_header_data, :text
    remove_column :freelancer_profiles, :header_color, :string
    remove_column :freelancer_profiles, :header_source, :string
    remove_column :freelancer_profiles, :stripe_account_id, :string
    remove_column :freelancer_profiles, :stripe_account_status, :text
    remove_column :freelancer_profiles, :currency, :string
    remove_column :freelancer_profiles, :sales_tax_number, :string
    remove_column :freelancer_profiles, :job_types, :citext
    remove_column :freelancer_profiles, :special_avj_fees, :float
    remove_column :freelancer_profiles, :avj_credit, :float
    remove_column :freelancer_profiles, :business_tax_number, :string
  end
end
