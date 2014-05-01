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

  @browse_calendar
  Scenario: Browse maps
    When I go to Calendar
    Then I should see the markets in the calendar

  @search
  Scenario: Search markets
    When I go to Search
    And I do a search
    Then I see the markets matching my query