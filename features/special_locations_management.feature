Feature: Manage special locations
  I order to have hotspots
  I want manage special locations

  Background:
    Given I am logged in as an admin

  Scenario: Add special_location
    When I add a special_location
    Then I should be notified that the special_location has been added
    And I should see the special_location in the special_location list
 
  Scenario: Delete special_location
    When There are some special_locations
    And I delete a special_location
    Then I should be notified that the special_location has been deleted
    And I should not see the special_location in the special_location list

  Scenario: Update special_location
    When There are some special_locations
    And I edit a special_location
    Then I should be notified that I the special_location has been updated
    And I should see the special_location with the new name in the special_location list

  @special_locations
  Scenario: Browse markets by special_location
    When There is a market near a special_location
    And I browse the special_location
    Then I should see the markets special_location near the speacial location