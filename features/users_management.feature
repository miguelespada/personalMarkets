Feature: Users management
  I order to have manage my users
  As admin
  I want to edit users

  Background: 
    Given there are some users
    And I go to Users

  Scenario: See User List
    Then I should see the list of users

  Scenario: Delete User 
    When I delete one user
    Then I should not see the user