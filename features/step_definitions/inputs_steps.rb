# frozen_string_literal: true

When("I fill {string} with {string}") do |field, value|
  fill_in field, with: value
end

When("I fill in the fields") do |table|
  table.rows_hash.each { |field, value| fill_in(field.strip, with: value.strip) }
end

When("I select from {string} the option {string}") do |select_input, option|
  select(option, from: select_input)
end
