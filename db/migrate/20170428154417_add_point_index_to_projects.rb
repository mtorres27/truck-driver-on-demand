# frozen_string_literal: true

# https://github.com/pairshaped/postgis-on-rails-example
class AddPointIndexToProjects < ActiveRecord::Migration[5.1]
  def up
    execute(
      <<-SQL.squish,
        create index index_on_projects_loc ON projects using gist (
          ST_GeographyFromText(
            'SRID=4326;POINT(' || projects.lng || ' ' || projects.lat || ')'
          )
        )
      SQL
    )
  end

  def down
    execute %(drop index index_on_projects_loc)
  end
end
