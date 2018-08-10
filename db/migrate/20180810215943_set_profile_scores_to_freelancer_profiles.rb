class SetProfileScoresToFreelancerProfiles < ActiveRecord::Migration[5.1]
  def up
    FreelancerProfile.find_each do |profile|
      profile.update_column(:profile_score, profile.freelancer&.score)
    end
  end

  def down
  #   Nothing to do here
  end
end
