Feature: Manage market
  In order to other users can see my market
  As a registered user
  I want to modify my market

  Background:
    Given I am logged in
    And I add a market
    And I go to my markets page

  Scenario: Modify market
    When I edit my market
    Then I should see my personal market page with the new data
    And I should be notified that the market has been succesfully updated

  @coordinates
  Scenario: Add coordinates to a market

  @delete
  Scenario: delete market
