Feature: Driver user login
  As an existing Driver user
  I want to go to login page and enter my credentials
  Then I see my Driver profile

Scenario: A Driver user enters valid credentials
  Given Exists an full registered driver user with email "john@doe.com" and password "password"
  When I go to login page
  And I fill "Email Address" with "john@doe.com"
  And I fill "Password" with "password"
  And I press "Login"
  Then I should be on "/driver"
  And I should see "Search Jobs"

Scenario: A Driver user enters invalid credentials
  Given Exists an full registered driver user with email "john@doe.com" and password "password"
  When I go to login page
  And I fill "Email Address" with "john@doe.com"
  And I fill "Password" with "no-valid"
  And I press "Login"
  Then I should see "Hey there, login to get started"
