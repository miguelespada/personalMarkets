Feature: Browse markets
  As a user
  I want to browse markets

  Background:
  Given There are some indexed markets

  @browse
  Scenario: I want to see the list of Markets
    When I go to Markets
    Then I should see all the markets

  @browse
  Scenario: I want to see the full description of a market
    When I go to the Markets
    And I click the details link of a market
    Then I should see the full description of a market

  @browse
  Scenario: I want to see my markets
    Given I have some markets
    And I go to my markets
    Then I should see all my markets