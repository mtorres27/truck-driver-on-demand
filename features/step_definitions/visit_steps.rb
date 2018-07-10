When("I go to the homepage") do
  visit root_path
end

When("I go to login page") do
  visit new_user_session_path
end

When("Show me the page") do
  save_and_open_page
end
