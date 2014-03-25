Feature: Browse markets
  As a user
  I want to browse markets

  Background:
  Given There are some markets

  @browse
  Scenario: Browse the list of Markets
    When I go to Markets
    Then I should see all the markets

  @browse
  Scenario: See the full description of a market
    When I go to Markets
    And I click the details link of a market
    Then I should see the full description of a market

  @browse
  Scenario: Browse by tag
    And I go to Tag list
    And I select one tag
    Then I see the markets matching my query

  @browse
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

  @seach
  Scenario: Search markets
    When I go to Search
    And I do a search
    Then I see the markets matching my query