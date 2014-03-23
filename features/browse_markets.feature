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
    And I go to tag list
    And I select one tag
    Then I see the markets matching the tag