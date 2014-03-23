Feature: Browse markets
  As a user
  I want to browse markets

  Background:
  Given There are some indexed markets

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
    Then I see the markets matching the tag

  @browse
  Scenario: Browse by tag
    When I go to category list
    And I select one category
    Then I see the markets matching the category

  @browse_map @javascript
  Scenario: Browse maps
    When I go to maps
    Then I should see a marker on the map
    And The market has tooltip