Feature: Company Registration
  As a non existing user
  I want to register as a company

Scenario: Filling fields for Step 1
  Given I go to the homepage
  When I press "Register as a company"
  Then I should see "You're on your way to finding your next great hire."
  When I fill in the fields
    | First Name        | John          |
    | Last Name         | Doe           |
    | Email Address     | john@doe.com  |
    | Enter a password  | password      |
    | Confirm password  | password      |
  And I check "company_user_accept_terms_of_service"
  And I press "Next Step"
  Then I should be on company registration step 2

Scenario: Filling fields for Step 2
  Given I filled company registration step 1
  And I am on company step 2
  When I fill in the fields
    | Company Name | Acme Co |
    | Website           | www.example.com |
    | City         | Chicago |
  And I select from "Country" the option "United States"
  And I select from "company_state" the option "Illinois"
  And I press "Next Step"
  Then I should be on company registration step 3

Scenario: Filling fields for Step 3
  Given I filled company registration step 2
  And I am on company step 3
  And I check "company_job_markets_corporate_meetings"
  And I check "company_job_markets_government_meetings"
  And I press "Complete Registration"
  Then I should be on confirm email page
