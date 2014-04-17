@session
Feature: User session
  I order to have manage my wall
  I want to create and account and acess my accout

  Scenario: Sign up
    When I sign up
    Then I should be notified that I have registered succesfully
    And I should see that I am logged

  Scenario: Sign in 
    Given I am a registered user
    When I sign in
    Then I should be notified that the I signned in
    And I should see that I am logged

  Scenario: Sign out
    Given I am logged in
    When I sign out
    Then I should be notified that the I signned out
    And I should not see that I am logged