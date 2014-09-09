@special_locations 
Feature: Manage special locations
  I order to have hotspots
  I want manage special locations

  Background:
    Given I am logged in as an admin

  Scenario: Add special_location
    When I add a special_location
    Then I should be notified that the special_location has been added
    And I should see the special_location in the special_location list
 
 Scenario: Add important special_location
    When I add a importnt special_location
    Then I should be notified that the special_location has been added
    And I should see the special_location in the navigation bar
 
  Scenario: Delete special_location
    When There are some special_locations
    And I delete a special_location
    Then I should be notified that the special_location has been deleted
    And I should not see the special_location in the special_location list

  Scenario: Update special_location
    When There are some special_locations
    And I edit a special_location
    Then I should be notified that the special_location has been updated
    And I should see the special_location with the new name in the special_location list
