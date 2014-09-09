@javascript @create_market

Feature: Create market
  As a registered user
  I want to create a market
  So that I can publish it

  Background:
    Given I am logged in

  Scenario: Add Market
    When I create a market
    Then I should see the market page
    And I should be notified that the market has been added

  Scenario: It appears in my markets
    When I create a market
    Then I should see it in my markets
