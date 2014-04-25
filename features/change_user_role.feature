@user_management
Feature: Change User Role

  Background:
    Given I have access to users management

  Scenario: Change User Role to admin
    Given  A normal user
    When I make it admin
    Then It should have admin role

  Scenario: Change User Role to normal
    Given  A admin user
    When I make it normal
    Then It should have normal role
