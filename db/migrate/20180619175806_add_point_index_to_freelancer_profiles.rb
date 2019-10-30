# frozen_string_literal: true

class AddPointIndexToFreelancerProfiles < ActiveRecord::Migration[5.1]
  def up
    execute(
      <<-SQL.squish,
        create index index_on_freelancer_profiles_loc ON freelancer_profiles using gist (
          ST_GeographyFromText(
            'SRID=4326;POINT(' || freelancer_profiles.lng || ' ' || freelancer_profiles.lat || ')'
          )
        )
    SQL
    )
  end

  def down
    execute %(drop index index_on_freelancer_profiles_loc)
  end
end
