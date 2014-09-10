@user_management
Feature: Users management
  I order to have manage my users
  As admin
  I want to edit users

  Background: 
    Given I have access to users management
    And there are some users
    And I go to Users

  Scenario: Delete User 
    When I delete one user
    Then I should not see the user

  Scenario: Desactivate User
    When I desactivate one user
    Then It should have inactive state

