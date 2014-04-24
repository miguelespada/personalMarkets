Feature: Change User Role

  Scenario: Change User Role to admin
    Given  A normal user
    When I make it admin
    Then It should have admin role

  @wip
  Scenario: Change User Role to normal
    Given  A admin user
    When I make it normal
    Then It should have normal role
