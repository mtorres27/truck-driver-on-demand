include Warden::Test::Helpers

Given("Exists an full registered company user with email {string} and password {string}") do |email, password|
  user = FactoryBot.create(:company_user, :confirmed, email: email, password: password)
  FactoryBot.create(:company, :registration_completed, company_user: user)
end

Given("I filled company registration step {int}") do |step|
  user = FactoryBot.create(:company_user)
  case step
  when 1
    FactoryBot.create(:company, company_user: user, name: nil, country: nil, city: nil, state: nil)
  when 2
    FactoryBot.create(:company, company_user: user, job_types: nil, job_markets: nil, registration_step: "job_info")
  when 3
    FactoryBot.create(
      :company, company_user: user, job_types: { live_events_staging_and_rental: "1" }, description: nil,
      established_in: nil, number_of_employees: nil, number_of_offices: nil, website: nil, area: nil, registration_step: "profile"
    )
  end
  login_as user, scope: :user
end

Given("I am on company step {int}") do |step|
  visit company_root_path
  case step
  when 2
    expect(page).to have_content("Company Name")
    expect(page).to have_content("State/province")
  when 3
    expect(page).to have_content("Please select a Job type")
  when 4
    expect(page).to have_content("Company Logo")
  else
    pending
  end
end

Then("I should be on company registration step {int}") do |step|
  case step
  when 2
    expect(current_path).to eq(company_registration_step_path(:personal))
  when 3
    expect(current_path).to eq(company_registration_step_path(:job_info))
  when 4
    expect(current_path).to eq(company_registration_step_path(:profile))
  else
    pending
  end
end

Then("I should be on confirm email page") do
  expect(current_path).to eq(confirm_email_path)
end