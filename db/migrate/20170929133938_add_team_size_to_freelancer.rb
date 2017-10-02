class AddTeamSizeToFreelancer < ActiveRecord::Migration[5.1]
  def change
    add_column :freelancers, "freelancer_team_size", :string
    add_column :freelancers, "freelancer_type", :string
  end
end
