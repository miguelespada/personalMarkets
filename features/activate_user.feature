@user_management
Feature: Activate user
  I order allow user to login
  As admin
  I want to activate a user

  Scenario: Activate user
    Given I have access to users management
    And an inactive user
    And I go to Users
    When I activate it
    Then It should have active state

