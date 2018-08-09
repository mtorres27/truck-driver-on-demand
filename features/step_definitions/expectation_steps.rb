Then("I should see {string}") do |string|
  expect(page).to have_content(string)
end

Then("I should be on {string}") do |url|
  expect(current_path).to eq(url)
end

Then("I should not see {string}") do |string|
  expect(page).not_to have_content(string)
end
