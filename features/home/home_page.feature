Feature: Visit HomePage
  As a non-login user
  I want to visit the homepage
  So I can see it is available

Scenario: Non logged in users sees the login page
  When I go to the homepage
  Then I should see "Choose the type of account you'd like to continue with"
