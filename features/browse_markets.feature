@browse
Feature: Browse markets
  As a user
  I want to browse markets

  Background:
  Given There are some published markets

  @browse_market
  Scenario: See the full description of a market
    When I go to Markets
    And I click the details link of a market
    Then I should see the full description of a market
