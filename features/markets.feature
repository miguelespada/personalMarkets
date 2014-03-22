Feature: Manage market
  In order to other users can see my market
  As a registered user
  I want to add and manage a market

  Background:
    Given I am logged in

  Scenario: Add Market
    When I add market
    Then I should see the market page
    And I should be notified that the market has been added

  Scenario: Modify market

  @coordinates
  Scenario: Add coordinates to a market


  @delete
  Scenario: delete market
