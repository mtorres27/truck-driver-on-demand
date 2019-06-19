Feature: Freelancer Registration
  As a non existing user
  I want to register as a freelancer

Scenario: Filling fields for Step 1
  Given I go to the homepage
  When I press "Register as an AV Pro"
  Then I should see "By creating an account, you agree to the AV Junction Terms & Conditions, Privacy and Code of Conduct"
  When I fill in the fields
    | First Name        | John          |
    | Last Name         | Doe           |
    | Email Address     | john@doe.com  |
    | Phone Number      | 1234567890    |
    | Enter a password  | password      |
    | Confirm password  | password      |
  And I check "freelancer_accept_terms_of_service"
  And I press "Next Step"
  Then I should be on freelancer registration step 2

Scenario: Filling fields for Step 2
  Given I filled freelancer registration step 1
  And I am on freelancer step 2
  When I fill in the fields
    | Company Name | Acme Co |
    | City         | Chicago |
  And I select from "Country" the option "United States"
  And I select from "freelancer_profile_state" the option "Illinois"
  And I press "Next Step"
  Then I should be on freelancer registration step 3

Scenario: Filling fields for Step 3
  Given I filled freelancer registration step 2
  And I am on freelancer step 3
  And I check "freelancer_profile_job_markets_broadcast"
  And I check "freelancer_profile_job_functions_audio_technician"
  And I check "freelancer_profile_job_markets_corporate_meetings"
  And I check "freelancer_profile_job_functions_assistant_stage_manager"
  And I press "Complete Registration"
  Then I should be on confirm email page
