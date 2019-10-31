# frozen_string_literal: true

# https://github.com/pairshaped/postgis-on-rails-example
class AddPointIndexToFreelancers < ActiveRecord::Migration[5.1]
  def up
    execute(
      <<-SQL.squish,
        create index index_on_freelancers_loc ON freelancers using gist (
          ST_GeographyFromText(
            'SRID=4326;POINT(' || freelancers.lng || ' ' || freelancers.lat || ')'
          )
        )
      SQL
    )
  end

  def down
    execute %(drop index index_on_freelancers_loc)
  end
end
