# frozen_string_literal: true

# https://github.com/pairshaped/postgis-on-rails-example
class AddPointIndexToCompanies < ActiveRecord::Migration[5.1]
  def up
    execute(
      <<-SQL.squish,
        create index index_on_companies_loc ON companies using gist (
          ST_GeographyFromText(
            'SRID=4326;POINT(' || companies.lng || ' ' || companies.lat || ')'
          )
        )
      SQL
    )
  end

  def down
    execute %(drop index index_on_companies_loc)
  end
end
