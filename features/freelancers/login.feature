Feature: Freelancer user login
  As an existing Freelancer user
  I want to go to login page and enter my credentials
  Then I see my Freelancer profile

Scenario: A Freelancer user enters valid credentials
  Given Exists an full registered freelancer user with email "john@doe.com" and password "password"
  When I go to login page
  And I fill "Email Address" with "john@doe.com"
  And I fill "Password" with "password"
  And I press "Login"
  Then I should be on "/freelancer"
  And I should see "Search Jobs"

Scenario: A Freelancer user enters invalid credentials
  Given Exists an full registered freelancer user with email "john@doe.com" and password "password"
  When I go to login page
  And I fill "Email Address" with "john@doe.com"
  And I fill "Password" with "no-valid"
  And I press "Login"
  Then I should see "Hey there, login to get started"
