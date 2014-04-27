@browse
Feature: Browse markets
  As a user
  I want to browse markets

  Background:
  Given There are some published markets

  Scenario: See the full description of a market
    When I go to Markets
    And I click the details link of a market
    Then I should see the full description of a market

  @browse
  Scenario: Browse by tag
    And I go to Tag list
    And I select one tag
    Then I see the markets matching my query

  @browse_category  
  Scenario: Browse by category
    When I go to Category list
    And I select one category
    Then I see the markets matching my query

  @browse_map @javascript
  Scenario: Browse map
    When I go to Map
    Then I should see a marker on the map
    And The market has tooltip

  @browse_calendar
  Scenario: Browse maps
    When I go to Calendar
    Then I should see the markets in the calendar

  @search
  Scenario: Search markets
    When I go to Search
    And I do a search
    Then I see the markets matching my query

  @ajaxSearch @javascript
  Scenario: Search markets with ajax
    When I go to Search
    And I select range
    Then I see the markets matching my query

  @ajaxSearch @javascript
  Scenario: Search markets with ajax wrong range
    When I go to Search
    And I select incorrect range
    Then I should not see the markets