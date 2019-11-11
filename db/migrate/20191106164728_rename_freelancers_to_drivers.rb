class RenameFreelancersToDrivers < ActiveRecord::Migration[5.1]
  def self.up
    rename_table :freelancer_profiles, :driver_profiles
    rename_column :driver_profiles, :freelancer_reviews_count, :driver_reviews_count
    rename_column :driver_profiles, :freelancer_team_size, :driver_team_size
    rename_column :driver_profiles, :freelancer_type, :driver_type
    rename_column :driver_profiles, :valid_freelancer, :valid_driver
    rename_column :driver_profiles, :freelancer_id, :driver_id
    rename_index :driver_profiles, 'index_on_freelancer_profiles_loc', 'index_on_driver_profiles_loc'
    rename_index :driver_profiles, 'index_on_freelancers_loc', 'index_on_drivers_loc'
    rename_column :applicants, :freelancer_id, :driver_id
    rename_column :certifications, :freelancer_id, :driver_id
    rename_column :companies, :saved_freelancers_ids, :saved_drivers_ids
    rename_column :company_favourites, :freelancer_id, :driver_id
    rename_column :company_reviews, :freelancer_id, :driver_id
    rename_column :favourites, :freelancer_id, :driver_id
    rename_table :freelancer_affiliations, :driver_affiliations
    rename_column :driver_affiliations, :freelancer_id, :driver_id
    rename_table :freelancer_clearances, :driver_clearances
    rename_column :driver_clearances, :freelancer_id, :driver_id
    rename_table :freelancer_insurances, :driver_insurances
    rename_column :driver_insurances, :freelancer_id, :driver_id
    rename_table :freelancer_portfolios, :driver_portfolios
    rename_column :driver_portfolios, :freelancer_id, :driver_id
    rename_table :freelancer_reviews, :driver_reviews
    rename_column :driver_reviews, :freelancer_id, :driver_id
    rename_column :friend_invites, :freelancer_id, :driver_id
    rename_column :job_favourites, :freelancer_id, :driver_id
    rename_column :job_invites, :freelancer_id, :driver_id
  end

  def self.down
    rename_table :driver_profiles, :freelancer_profiles
    rename_column :freelancer_profiles, :driver_reviews_count, :freelancer_reviews_count
    rename_column :freelancer_profiles, :driver_team_size, :freelancer_team_size
    rename_column :freelancer_profiles, :driver_type, :freelancer_type
    rename_column :freelancer_profiles, :valid_driver, :valid_freelancer
    rename_column :freelancer_profiles, :driver_id, :freelancer_id
    rename_index :driver_profiles, 'index_on_driver_profiles_loc', 'index_on_freelancer_profiles_loc'
    rename_index :driver_profiles, 'index_on_drivers_loc', 'index_on_freelancers_loc'
    rename_column :applicants, :driver_id, :freelancer_id
    rename_column :certifications, :driver_id, :freelancer_id
    rename_column :companies, :saved_drivers_ids, :saved_freelancers_ids
    rename_column :company_favourites, :driver_id, :freelancer_id
    rename_column :company_reviews, :driver_id, :freelancer_id
    rename_column :favourites, :driver_id, :freelancer_id
    rename_table :driver_affiliations, :freelancer_affiliations 
    rename_column :freelancer_affiliations, :driver_id, :freelancer_id
    rename_table :driver_clearances, :freelancer_clearances
    rename_column :freelancer_clearances, :driver_id, :freelancer_id
    rename_table :driver_insurances, :freelancer_insurances
    rename_column :freelancer_insurances, :driver_id, :freelancer_id
    rename_table :driver_portfolios, :freelancer_portfolios
    rename_column :freelancer_portfolios, :driver_id, :freelancer_id
    rename_table :driver_reviews, :freelancer_reviews
    rename_column :freelancer_reviews, :driver_id, :freelancer_id
    rename_column :friend_invites, :driver_id, :freelancer_id
    rename_column :job_favourites, :driver_id, :freelancer_id
    rename_column :job_invites, :driver_id, :freelancer_id
  end
end
