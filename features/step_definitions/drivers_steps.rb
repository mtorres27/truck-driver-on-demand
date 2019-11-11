# frozen_string_literal: true

include Warden::Test::Helpers

Given("Exists an full registered driver user with email {string} and password {string}") do |email, password|
  profile = FactoryBot.create(:driver_profile, :registration_completed)
  FactoryBot.create(:driver, :confirmed, email: email, password: password, driver_profile: profile)
end

Given("I filled driver registration step {int}") do |step|
  profile = case step
            when 1
              FactoryBot.create(:driver_profile)
            when 2
              FactoryBot.create(:driver_profile, registration_step: "job_info")
            when 3
              FactoryBot.create(:driver_profile,
                                job_types: { live_events_staging_and_rental: "1" }, registration_step: "profile")
            end
  user = FactoryBot.create(:driver, :confirmed, driver_profile: profile)
  login_as user, scope: :user
end

Given("I am on driver step {int}") do |step|
  visit driver_root_path
  case step
  when 2
    expect(page).to have_content("Company Name")
    expect(page).to have_content("State/province")
  when 3
    expect(page).to have_content("System Integration")
  else
    pending
  end
end

Then("I should be on driver registration step {int}") do |step|
  case step
  when 2
    expect(current_path).to eq(driver_registration_step_path(:personal))
  when 3
    expect(current_path).to eq(driver_registration_step_path(:job_info))
  when 4
    expect(current_path).to eq(driver_registration_step_path(:profile))
  else
    pending
  end
end
