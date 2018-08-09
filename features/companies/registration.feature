Feature: Company Registration
  As a non existing user
  I want to register as a company

Scenario: Filling fields for Step 1
  Given I go to the homepage
  When I press "Register as a company"
  Then I should see "Register as a Company"
  When I fill in the fields
    | First Name        | John          |
    | Last Name         | Doe           |
    | Email Address     | john@doe.com  |
    | Enter a password  | password      |
    | Confirm password  | password      |
  And I check "company_user_accept_terms_of_service"
  And I press "Continue"
  Then I should be on company registration step 2

Scenario: Filling fields for Step 2
  Given I filled company registration step 1
  And I am on company step 2
  When I fill in the fields
    | Company Name | Acme Co |
    | City         | Chicago |
  And I select from "Country" the option "United States"
  And I select from "company_state" the option "Illinois"
  And I press "Continue"
  Then I should be on company registration step 3

Scenario: Filling fields for Step 3
  Given I filled company registration step 2
  And I am on company step 3
  When I check "company_job_types_live_events_staging_and_rental"
  And I check "company_job_markets_corporate_meetings"
  And I check "company_job_markets_government_meetings"
  And I press "Continue"
  Then I should be on company registration step 4

Scenario: Filling fields for Step 4
  Given I filled company registration step 3
  And I am on company step 4
  When I fill in the fields
    | About the company | Just a small description |
    | Year Est          | 2 |
    | # Offices         | 2 |
    | Website           | www.example.com |
    | Service Areas     | Entertainment, TV |
  And I select from "# Employees" the option "1 - 10"
  And I press "Complete"
  Then I should be on confirm email page

Scenario: Skipping registrations steps 3 and 4
  Given I filled company registration step 1
  And I am on company step 2
  When I fill in the fields
    | Company Name | Acme Co |
    | City         | Chicago |
  And I select from "Country" the option "United States"
  And I select from "company_state" the option "Illinois"
  And I press "Continue"
  Then I should see "Please select a Job type"
  When I press "Skip"
  Then I should see "Company Logo"
  When I press "Skip & Register"
  Then I should be on confirm email page
