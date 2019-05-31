include Warden::Test::Helpers

Given("Exists an full registered freelancer user with email {string} and password {string}") do |email, password|
  profile = FactoryBot.create(:freelancer_profile, :registration_completed)
  FactoryBot.create(:freelancer, :confirmed, email: email, password: password, freelancer_profile: profile)
end

Given("I filled freelancer registration step {int}") do |step|
  profile = case step
    when 1
      FactoryBot.create(:freelancer_profile)
    when 2
      FactoryBot.create(:freelancer_profile, registration_step: "job_info")
    when 3
      FactoryBot.create(:freelancer_profile, job_types: { live_events_staging_and_rental: "1" }, registration_step: "profile")
    end
  user = FactoryBot.create(:freelancer, :confirmed, freelancer_profile: profile)
  login_as user, scope: :user
end

Given("I am on freelancer step {int}") do |step|
  visit freelancer_root_path
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

Then("I should be on freelancer registration step {int}") do |step|
  case step
  when 2
    expect(current_path).to eq(freelancer_registration_step_path(:personal))
  when 3
    expect(current_path).to eq(freelancer_registration_step_path(:job_info))
  when 4
    expect(current_path).to eq(freelancer_registration_step_path(:profile))
  else
    pending
  end
end
