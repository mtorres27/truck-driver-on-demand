Feature: Freelancer Registration
  As a non existing user
  I want to register as a freelancer

Scenario: Filling fields for Step 1
  Given I go to the homepage
  When I press "Register as a Freelancer"
  Then I should see "Register as a Freelancer"
  When I fill in the fields
    | First Name        | John          |
    | Last Name         | Doe           |
    | Email Address     | john@doe.com  |
    | Enter a password  | password      |
    | Confirm password  | password      |
  And I check "freelancer_accept_terms_of_service"
  And I press "Continue"
  Then I should be on freelancer registration step 2

Scenario: Filling fields for Step 2
  Given I filled freelancer registration step 1
  And I am on freelancer step 2
  When I fill in the fields
    | Company Name | Acme Co |
    | City         | Chicago |
  And I select from "Country" the option "United States"
  And I select from "freelancer_profile_state" the option "Illinois"
  And I press "Continue"
  Then I should be on freelancer registration step 3

Scenario: Filling fields for Step 3
  Given I filled freelancer registration step 2
  And I am on freelancer step 3
  When I check "freelancer_profile_job_types_system_integration"
  And I check "freelancer_profile_job_types_live_events_staging_and_rental"
  And I check "freelancer_profile_job_markets_broadcast"
  And I check "freelancer_profile_job_functions_audio_technician"
  And I check "freelancer_profile_job_markets_corporate_meetings"
  And I check "freelancer_profile_job_functions_assistant_stage_manager"
  And I press "Continue"
  Then I should be on freelancer registration step 4

Scenario: Filling fields for Step 4
  Given I filled freelancer registration step 3
  And I am on freelancer step 4
  When I fill in the fields
    | Tagline     | Just a tagline description   |
    | Biography   | Just a Biography description |
  And I press "Complete"
  Then I should be on confirm email page

Scenario: Skipping registrations steps 3 and 4
  Given I filled freelancer registration step 1
  And I am on freelancer step 2
  When I fill in the fields
    | Company Name | Acme Co |
    | City         | Chicago |
  And I select from "Country" the option "United States"
  And I select from "freelancer_profile_state" the option "Illinois"
  And I press "Continue"
  Then I should see "Please select a Job type"
  When I press "Skip"
  Then I should see "Profile Picture"
  When I press "Skip & Register"
  Then I should be on confirm email page
