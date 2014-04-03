Feature: Add market
  In order to other users can see my market
  As a registered user
  I want to add market

  Background:
    Given I am logged in
    When I add a market

  Scenario: Add Market
    Then I should see the market page
    And I should be notified that the market has been added
